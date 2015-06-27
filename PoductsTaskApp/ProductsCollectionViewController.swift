//
//  ProductsCollectionViewController.swift
//  PoductsTaskApp
//
//  Created by Ayman  on 6/18/15.
//  Copyright (c) 2015 ayman mohamed. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ProductsCollectionViewController: UIViewController {
  
  // MARK: Instance Variables
  @IBOutlet weak var productCollectionView: UICollectionView!
  @IBOutlet weak var productActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var productActivityTopConstraint: NSLayoutConstraint!
  
  var productCellNib :UINib!
  var allProductsArray :[Product]
  var imageCache : [String : UIImage]  // cache images came from servier
  var fromProductId :Double!
  var AlertTitle :String!
  var AlertMessage :String!
  let productsCountPerPage :Double!
  let productCellIdentifier :String!
  
  // using custum waterfallLayout to collectionview layout
  let productCollectionViewLayout : CollectionViewWaterfallLayout!
  
  // MARK: init
  required init(coder aDecoder: NSCoder) {
    allProductsArray = []
    imageCache = [:]
    fromProductId = 0.0
    AlertTitle = ""
    AlertMessage = ""
    productsCountPerPage = 20.0
    productCellIdentifier = "ProductCell"
    productCollectionViewLayout = CollectionViewWaterfallLayout()
    productCollectionViewLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    productCollectionViewLayout.headerInset = UIEdgeInsetsMake(20, 0, 0, 0)
    productCollectionViewLayout.minimumColumnSpacing = 10
    productCollectionViewLayout.minimumInteritemSpacing = 10
    super.init(coder: aDecoder)
  }
  
  // MARK: View Lifecycle
  override func viewDidLoad() {
    productCellNib = UINib(nibName: "ProductCell", bundle: nil)
    productCollectionView.registerNib(productCellNib, forCellWithReuseIdentifier: productCellIdentifier)
    productCollectionView.collectionViewLayout = productCollectionViewLayout
    self.title = "Products"
    super.viewDidLoad()
    self.loadProducts()
  }
  
  // MARK: Server Requests
  func loadProducts() {
    if (LibraryApi.sharedInstance.isConnectedToNetwork()){
      self.productActivityIndicator.startAnimating()
      LibraryApi.sharedInstance.getProducts(productsCountPerPage, from: fromProductId, completionHandler: { responseObject, data, error in
        self.productActivityIndicator.stopAnimating()
        if (error != nil) {
          self.AlertMessage = " Sorry, something went wrong "
          self.createAlertWithDismissButton(self.AlertTitle , message: self.AlertMessage)
        } else {
          let json = JSON(data!)     // using SwiftyJSON to deal with JSON data
          let jsonArray = json.arrayValue
          for jsonObj in jsonArray {
            self.allProductsArray.append(ProductWapper.WrapeJsonToProduct(jsonObj))
          }
          
          self.productCollectionView.reloadData()
          let lastProductIndex  = self.allProductsArray.count - 1
          let startProductId   = self.allProductsArray[lastProductIndex].id + 1
          self.fromProductId = startProductId
        } // end of else
        } //end of compeletion handler
      )// end of function call
    } else {
      self.AlertMessage = "No internet Connection "
      self.createAlertWithDismissButton(self.AlertTitle , message: self.AlertMessage)
    }
  }
  
  // MARK: Helper Methods
  func createAlertWithDismissButton(title: String, message: String) {
    let alertController = UIAlertController(title: title, message:
      message, preferredStyle: UIAlertControllerStyle.Alert)
    
    let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("dismiss", comment: ""))
    alertView.show()
    
  }
  
}

extension ProductsCollectionViewController :UICollectionViewDataSource,UICollectionViewDelegate,CollectionViewWaterfallLayoutDelegate {
  
  // MARK: Collection View Data Source
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return allProductsArray.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let productCell: ProductCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(productCellIdentifier, forIndexPath: indexPath) as! ProductCollectionViewCell
    
    let product = self.allProductsArray[indexPath.row]
    if var image = self.imageCache[product.imageUrl]  {
      productCell.productImage.image = image
    } else {
      LibraryApi.sharedInstance.getProductImageWithUrl(product.imageUrl, completionHandler: { responseObject, data, error in
        if (data != nil) {
          if let imageResponse = UIImage(data: data as! NSData) {
            self.imageCache[product.imageUrl] = imageResponse
            productCell.productImage.image = imageResponse
          }
          
        } else {
          println(error)
        } // end of else
        } //end of compeletion handler
      )
    }
    self.configureProductCell(productCell, product: product)
    
    return productCell
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout:UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      
      return self.calculateHeightForConfiguredSizingCell(indexPath)
  }
  
  // MARK: Collection View Delegate
  func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    if (indexPath.row == self.allProductsArray.count - 1) {
      productActivityTopConstraint.constant = self.view.frame.height - 95
      // load more products
      self.loadProducts()
    }
  }
  
  func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    let productCell = productCollectionView.dequeueReusableCellWithReuseIdentifier("ProductCell", forIndexPath: indexPath) as! ProductCollectionViewCell
    productCell.productImage.image = nil
    productCell.productDescription.text = ""
  }
  
  // MARK: Size Method
  func calculateHeightForConfiguredSizingCell(indexPath :NSIndexPath) -> CGSize {
    // Use fake cell to calculate height
    let reuseIdentifier = productCellIdentifier
    var cell: ProductCollectionViewCell?
    if cell == nil {
      cell = NSBundle.mainBundle().loadNibNamed("ProductCell", owner: self, options: nil)[0] as? ProductCollectionViewCell
    }
    // Config cell and let system determine size
    let product = self.allProductsArray[indexPath.row]
    self.configureProductCell(cell!, product: product)
    cell!.productImage.frame = CGRectMake(0.0, 0.0, CGFloat (150) , CGFloat(product.imageHeight))
    let descriptionHeight = cell?.productDescription.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    let imageHeight  = CGFloat(product.imageHeight)
    let ProductCellHeight = imageHeight + descriptionHeight!.height
    let ProductCellSize = CGSize(width: 150, height: ProductCellHeight)
    return ProductCellSize
  }
  
  func configureProductCell (productCell : ProductCollectionViewCell,product : Product) -> ProductCollectionViewCell {
    productCell.productPrice.text = "$" + String(format:"%i",  product.price)
    productCell.productDescription.text = product.productDescription
    let imageUrl = product.imageUrl
    return productCell
  }
  
}