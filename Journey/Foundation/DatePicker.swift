//
//  DatePicker.swift
//  Journey
//
//  Created by ltebean on 16/2/19.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

class DatePicker: UIViewController {
    
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!
    @IBOutlet weak var picker: UIDatePicker!
    
    let pickerTranslation = CGFloat(216 + 44)
    
    var initialDate: NSDate?
    var selected: (NSDate -> Void)?
    var cancelled: (() -> Void)?
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        cancelled?()
        close()
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        selected?(picker.date)
        close()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        pickerBottom.constant = -pickerTranslation
        if let date = initialDate {
            picker.date = date
        }
        view.layoutIfNeeded()

        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.pickerBottom.constant = 0
                self.view.layoutIfNeeded()
            },
            completion: { finished in
            }
        )
    }
    
    func close() {
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.pickerBottom.constant = -self.pickerTranslation
                self.view.layoutIfNeeded()
            },
            completion: { finished in
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
            }
        )
    }
    
    static func showInViewController(vc: UIViewController, initialDate: NSDate?, selected: (NSDate -> Void), cancelled: (() -> Void)) {
        let picker = R.storyboard.foundation.datePicker()!
        picker.selected = selected
        picker.initialDate = initialDate
        picker.cancelled = cancelled
        picker.modalTransitionStyle = .CrossDissolve
        picker.modalPresentationStyle = .Custom
        vc.presentViewController(picker, animated: true, completion: nil)
    }

    
}
