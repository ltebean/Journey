//
//  MomentEditorViewController.swift
//  Journey
//
//  Created by ltebean on 16/2/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit
import GLPubSub

class MomentEditorViewController: UIViewController {

    let screenHeight = UIScreen.mainScreen().bounds.size.height
    let imagePicker = ImagePicker()
    let photoService = PhotoService.sharedInstance
    let momentService = MomentService.sharedInstance
    let homeMomentTransitionDelegate = HomeMomentTransitionDelegate()
    
    let titleFieldPlaceholder = "Enter title"
    let textViewPlaceholder = "Enter text"
    let dateButtonPlaceholder = "Choose date"
    let placeholderColor = UIColor(hex: 0xc7c7c7)
    let textColor = UIColor(hex: 0x333333)

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var saveButton: PrimaryButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var deleteButton: PrimaryButton!
    
    @IBOutlet var seperatorHeight: [NSLayoutConstraint]!

    var moment: Moment?
    var seletedDate: NSDate?
    var loaded = false
    var isEdit = false
    var deleted = false
    var needsSaveImage = false
    var keyboardIsShowing = false
    
    var imageViewTranslationY : CGFloat {
        return -(view.bounds.size.height / 4)
    }
    
    var containerViewTopValue: CGFloat {
        if view.bounds.width > view.bounds.height {
            return view.bounds.height / 7 * 2
        } else {
             return view.bounds.height / 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.textContainerInset = UIEdgeInsetsZero
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        textView.text = textViewPlaceholder
        textView.font = UIFont.regularFont(size: 15)
        
        titleField.delegate = self;
        dateButton.setTitle(dateButtonPlaceholder, forState:.Normal)
        
        containerView.applyDefaultShadow()
        
        for height in seperatorHeight {
            height.constant = 0.5
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !keyboardIsShowing else {
            return
        }
        imageViewCenterY.constant = imageViewTranslationY
        containerViewTop.constant = containerViewTopValue
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard !loaded else {
            return
        }
        
        if let moment = moment {
            isEdit = true

            imageView.image = photoService.syncLoadImage(uuid: moment.photoUuid)
            titleField.text = moment.title
            
            setTextViewText(moment.text)
            
            seletedDate = moment.date
            
            dateButton.setTitle(moment.date.toDateString(), forState: .Normal)
            dateButton.setTitleColor(textColor, forState: .Normal)
        }
        
        if isEdit {
            saveButton.hidden = true
            deleteButton.hidden = false
        } else {
            saveButton.hidden = false
            deleteButton.hidden = true
        }
        updateSaveButton()
        loaded = true
        view.clipsToBounds = !isEdit
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if isEdit && !deleted {
            save()
        }
    }

    func setTextViewText(text: String) {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 2
        paraStyle.lineBreakMode = .ByWordWrapping
        textView.attributedText =  NSAttributedString(string: text, attributes: [
            NSFontAttributeName: UIFont.regularFont(size: 15),
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: paraStyle,
        ])
    }
    
    func updateSaveButton() {
        saveButton.enabled = seletedDate != nil && titleField.text != "" && textView.text != textViewPlaceholder && imageView.image != nil
    }
    
    
    func save() {
        guard let date = seletedDate, title = titleField.text, text = textView.text, image = imageView.image where title != titleFieldPlaceholder && text != textViewPlaceholder else {
            return
        }
        let data = moment ?? Moment()
        momentService.saveMoment(data, image: (needsSaveImage ? image : nil), write: { moment in
            moment.title = title
            moment.text = text
            moment.date = date
        })
        publish(MomentService.Event.MomentUpdated.rawValue, data: data.uuid)
        
    }
    
    func delete() {
        guard let moment = moment else {
            return
        }
        momentService.deleteMoment(moment)
        deleted = true
    }
    
    func close() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func adjustContainerViewWhenEditingInView(editingView: UIView, threshould: CGFloat=190) {
        keyboardIsShowing = true
        let frame = view.convertRect(editingView.frame, fromCoordinateSpace: editingView.superview!)
        let bottom = view.frame.height - frame.origin.y - frame.height
        let distance = bottom - threshould
        if distance < 0 {
            UIView.animateWithDuration(0.2, animations: {
                self.containerViewTop.constant = self.containerViewTopValue + distance
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func recoverContainerViewAfterEdit() {
        keyboardIsShowing = false
        UIView.animateWithDuration(0.2, animations: {
            self.containerViewTop.constant = self.containerViewTopValue
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: IBAction
extension MomentEditorViewController {
    
    @IBAction func dateButtonPressed(sender: AnyObject) {
        DatePicker.showInViewController(self,
            initialDate: moment?.date,
            selected: { date in
                self.seletedDate = date
                self.dateButton.setTitle(date.toDateString(), forState: .Normal)
                self.dateButton.setTitleColor(self.textColor, forState: .Normal)
            },
            cancelled: {
                
            }
        )
    }
    
    @IBAction func photoButtonPressed(sender: AnyObject) {
        imagePicker.didSelectImage = { image in
            self.imageView.image = image
            self.updateSaveButton()
            self.needsSaveImage = true
        }
        imagePicker.presentInViewController(self)
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        close()
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        save()
        view.clipsToBounds = false
        transitioningDelegate = homeMomentTransitionDelegate
        close()
    }

    @IBAction func deleteButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Delete?", message: nil, preferredStyle: .ActionSheet)
        let ok = UIAlertAction(title: "OK", style: .Destructive) { action in
            self.delete()
            self.transitioningDelegate = nil
            self.view.clipsToBounds = true
            self.close()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension MomentEditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        adjustContainerViewWhenEditingInView(textView)
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        recoverContainerViewAfterEdit()
        updateSaveButton()
    }
}

extension MomentEditorViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == textViewPlaceholder {
            setTextViewText("")
            textView.textColor = textColor
        }
        adjustContainerViewWhenEditingInView(textView, threshould: 275)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        recoverContainerViewAfterEdit()
        updateSaveButton()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


