//
//  PrimaryButton.swift
//  Journey
//
//  Created by ltebean on 16/2/19.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

@IBDesignable
class PrimaryButton: UIButton {

    @IBInspectable var defaultColor = UIColor(hex: 0x333333) {
        didSet {
            layer.borderColor = defaultColor.CGColor
            setTitleColor(defaultColor, forState: .Normal)
        }
    }
    
    let disabledColor = UIColor(hex: 0xcccccc)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override var enabled: Bool {
        didSet {
            if enabled {
                layer.borderColor = defaultColor.CGColor
            } else {
                layer.borderColor = disabledColor.CGColor
            }
        }
    }
    
    func setup() {
        clipsToBounds = true
        layer.borderColor = defaultColor.CGColor
        layer.borderWidth = 1
        setTitleColor(defaultColor, forState: .Normal)
        setTitleColor(disabledColor, forState: .Disabled)
    }

}
