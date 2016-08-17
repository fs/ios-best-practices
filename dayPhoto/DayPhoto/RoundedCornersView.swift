//
//  RoundedCornersView.swift
//  DayPhoto
//
//  Created by Nikita Asabin on 3.12.15.
//  Copyright (c) 2015 Flatstack. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
}
