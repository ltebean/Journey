//
//  UIView.swift
//  Journey
//
//  Created by ltebean on 16/2/19.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyDefaultShadow() {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0, 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 6
    }
}
