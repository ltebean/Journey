//
//  UIFont.swift
//  Journey
//
//  Created by ltebean on 16/2/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func regularFont(size size: CGFloat) -> UIFont {
        return UIFont(name: "Raleway-Regular", size: size)!
    }
    
    static func lightFont(size size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Light", size: size)!
    }
}