//
//  Product.swift
//  PoductsTaskApp
//
//  Created by Ayman  on 6/18/15.
//  Copyright (c) 2015 ayman mohamed. All rights reserved.
//

import Foundation

class Product: NSObject {
  
  // MARK: Instance Variables
  var id :Double!
  var productDescription :String!
  var imageWidth :Double!
  var imageHeight :Double!
  var imageUrl :String!
  var price :Int!
  
  // MARK: init
  override init () {
    super.init()
    self.id = 0
    self.productDescription = ""
    self.imageWidth = 0.0
    self.imageHeight = 0.0
    self.imageUrl = ""
    self.price = 0
  }
}