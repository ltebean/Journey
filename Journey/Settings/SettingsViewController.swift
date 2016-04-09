//
//  SettingsViewController.swift
//  Journey
//
//  Created by ltebean on 16/2/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        view.addGestureRecognizer(tap)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .Ended else {
            return
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func closeButtonPressed(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func feedbackButtonPressed(sender: AnyObject) {
        guard let url = NSURL(string:"mailto:yucong1118@gmail.com") else {
            return
        }
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func rateButtonPressed(sender: AnyObject) {
        guard let url = NSURL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1086435070&onlyLatestVersion=true&type=Purple+Software") else {
            return
        }
        UIApplication.sharedApplication().openURL(url);
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}
