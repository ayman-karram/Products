//
//  LibraryAPI.swift
//  PoductsTaskApp
//
//  Created by Ayman  on 6/18/15.
//  Copyright (c) 2015 ayman mohamed. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration

class LibraryApi :NSObject {
  
  // MARK: Singleton initialization
  class var sharedInstance: LibraryApi {
    
    struct Singleton {
      static let instance = LibraryApi()
    }
    
    return Singleton.instance
  }
  
  // MARK: ProductsAppUrls
  struct ProductsAppUrls {
    static var getProducts = "http://grapesnberries.getsandbox.com/products"
  }
  // MARK: Instance Variables
  var alamofireManager: Alamofire.Manager!
  
  // MARK: init
  override init() {
    alamofireManager = Alamofire.Manager()
  }

  // MARK: API Methods
  func getProducts(count: Double, from: Double, completionHandler: (responseObject: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void) {
    
    var url = ProductsAppUrls.getProducts
    
    alamofireManager.request(.GET, url, parameters: ["count": count, "from": from]).responseJSON { (request, response, data, error) in
      completionHandler(responseObject: response, data: data, error: error)
    }
  }
  
  func getProductImageWithUrl(url: String, completionHandler: (responseObject: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void) {
    
    alamofireManager.request(.GET, url).response { (request, response, data, error) in
      completionHandler(responseObject: response, data: data, error: error)
    }
  }
  
  // MARK: API Helper Methods
  func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
      SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
    }
    
    var flags: SCNetworkReachabilityFlags = 0
    if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
      return false
    }
    
    let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    
    return (isReachable && !needsConnection) ? true : false
  }
  
}