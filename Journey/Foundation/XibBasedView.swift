//
//  XibBasedView.swift
//  Noah
//
//  Created by ltebean on 15/10/15.
//  Copyright © 2015年 Glow. All rights reserved.
//

import UIKit

public class XibBasedView: UIView {
    
    public var contentView: UIView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    
    public func load() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!, bundle: bundle)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.frame = bounds
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(contentView)
    }
}
