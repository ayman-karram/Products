//
//  productPriceLabel.swift
//  ProductsTaskApp
//
//  Created by Ayman  on 6/21/15.
//  Copyright (c) 2015 ayman mohamed. All rights reserved.
//

import UIKit

class ProductPriceLabel: UILabel {
  
  // MARK: init
  override func awakeFromNib() {
    super.awakeFromNib()
    self.textAlignment = NSTextAlignment.Right
    self.textColor = UIColor.whiteColor()
    self.backgroundColor = productPriceBackgroundColor    // found in FontsAndColorsHelper.swift
    self.font = UIFont(name: appFontStyleLight, size: appFontSizeUltraSmall)
    self.layer.cornerRadius = 4
    self.clipsToBounds = true
  }

  // MARK: View Lifecycle
  override func drawTextInRect(rect: CGRect) {
    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets))
  }
  
  override func intrinsicContentSize() -> CGSize {
    var intrinsicSuperViewContentSize = super.intrinsicContentSize()
    intrinsicSuperViewContentSize.height += 10
    intrinsicSuperViewContentSize.width += 20

    return intrinsicSuperViewContentSize
  }
}
