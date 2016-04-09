//
//  MomentView.swift
//  Journey
//
//  Created by ltebean on 16/2/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

class MomentView: XibBasedView {

    let screenWidth = UIScreen.mainScreen().bounds.width
    let cardPadding = CGFloat(60)
    let photoService = PhotoService.sharedInstance
    let maxPullDownDistance = CGFloat(105)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var moment: Moment! {
        didSet {
            updateUI()
        }
    }
    
    override func load() {
        super.load()
        cardView.applyDefaultShadow()
    }
    
    func updateUI() {
        imageView.image = photoService.syncLoadImage(uuid: moment.photoUuid)
        titleLabel.text = moment.title
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 2
        paraStyle.lineBreakMode = .ByTruncatingTail
        
        textLabel.attributedText =  NSAttributedString(string: moment.text, attributes: [
            NSFontAttributeName: UIFont.regularFont(size: 15),
            NSForegroundColorAttributeName: UIColor(hex: 0x333333),
            NSParagraphStyleAttributeName: paraStyle,
        ])
        dateLabel.text = moment.date.toDateString()
    }
    
    func updateViewsWithProgress(progress: CGFloat) {        
        let tx = -progress * (cardPadding * 2 - 15)
        cardView.transform.tx = tx
    }
    
    func pullViewsWithDistance(distance: CGFloat) {
        var ty = distance / 6 + cardView.transform.ty
        if ty > maxPullDownDistance {
            ty = maxPullDownDistance * (1 + log10((fabs(ty) + 10) / maxPullDownDistance))
        }
        else if ty < 0 {
            ty = -20 * (1 + log10((fabs(ty) + 10) / maxPullDownDistance))
        }
        setViewsTranslationY(ty)
    }
    
    func finishPullViews() {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: [],
            animations: {
                if self.cardView.transform.ty > (self.maxPullDownDistance / 2) {
                    self.setViewsTranslationY(self.maxPullDownDistance)
                } else {
                    self.setViewsTranslationY(0)
                }
            },
            completion: { finished in
                
            }
        )
    }
    
    
    private func setViewsTranslationY(ty: CGFloat) {
        cardView.transform.ty = ty
        [titleLabel, dateLabel].forEach({ view in
            view.transform.ty = ty
        })
    }
}
