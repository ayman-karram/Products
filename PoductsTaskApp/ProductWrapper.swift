//
//  ProductWrapper.swift
//  PoductsTaskApp
//
//  Created by Ayman  on 6/18/15.
//  Copyright (c) 2015 ayman mohamed. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProductWapper {
  
  class func  WrapeJsonToProduct (jsonObjetc : JSON) -> Product {
    
    var productObject = Product()
    
    if let productId = jsonObjetc["id"].double {
      productObject.id = productId
    }
    if let productDescription = jsonObjetc["productDescription"].string {
      productObject.productDescription = productDescription
    }
    if let productImageWidth = jsonObjetc["image"]["width"].double {
      productObject.imageWidth = productImageWidth
    }
    if let productImageHeight = jsonObjetc["image"]["height"].double {
      productObject.imageHeight = productImageHeight
    }
    if let productImageUrl = jsonObjetc["image"]["url"].string {
      productObject.imageUrl = productImageUrl
    }
    if let productPrice = jsonObjetc["price"].int {
      productObject.price = productPrice
    }
    
    return productObject
  }
}