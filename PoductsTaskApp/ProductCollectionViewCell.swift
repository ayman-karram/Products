//
//  ProductCollectionViewCell.swift
//  PoductsTaskApp
//
//  Created by Ayman  on 6/19/15.
//  Copyright (c) 2015 ayman mohamed. All rights reserved.
//

import Foundation
import UIKit

class ProductCollectionViewCell :UICollectionViewCell {
  
  // MARK: Instance Variables
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var productDescription: UILabel!
  @IBOutlet weak var productPrice: ProductPriceLabel!
  
  // MARK: init
  override func awakeFromNib() {
    super.awakeFromNib()
    productDescription.textColor = darkGrayTextColor
    productDescription.font = UIFont(name:appFontStyleNormal , size: appFontSizeUltraSmall)
    productDescription.text  = ""
    productPrice.text = ""
  }
  
  
  
}