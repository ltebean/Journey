//
//  ImagePicker.swift
//  Noah
//
//  Created by ltebean on 15/11/10.
//  Copyright © 2015年 Glow. All rights reserved.
//

import UIKit

class ImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var viewController: UIViewController!
    
    var didSelectImage: ((image: UIImage) -> Void)?
    
    private let maxSize = CGSize(width: 3000, height: 3000)

    
    func presentInViewController(viewController: UIViewController, allowsEditing: Bool=false) {
        self.viewController = viewController
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .Default) { (action) in
            self.openPhotoPicker(.Camera, allowsEditing: allowsEditing)
        }
        let chooseAction = UIAlertAction(title: "Choose from library", style: .Default) { (action) in
            self.openPhotoPicker(.PhotoLibrary, allowsEditing: allowsEditing)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseAction)
        alertController.addAction(cancelAction)
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func openPhotoPicker(sourceType: UIImagePickerControllerSourceType, allowsEditing: Bool=false) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = allowsEditing
        viewController.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        selectImage(image)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectImage(pickedImage)
        }
        else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectImage(pickedImage)
        }
    }
    
    private func selectImage(image: UIImage) {
        didSelectImage?(image: image)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}




