//
//  String.swift
//  Journey
//
//  Created by ltebean on 16/2/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

public extension NSAttributedString {
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let boundingSize = CGSize(width: width, height: CGFloat.max)
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin
        let size = boundingRectWithSize(boundingSize, options: options, context: nil)
        return ceil(size.height)
    }
}