//
//  PhotoService.swift
//  Journey
//
//  Created by ltebean on 16/2/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//
import UIKit

class PhotoService {
    
    static let sharedInstance = PhotoService()
    
    private var imageCache: [String: UIImage] = [:]
    private let fileManager = FileManager.sharedInstance
    private let photoDir = "photos"
    
    func syncLoadImage(uuid uuid: String) -> UIImage? {
        if let cached = imageCache[uuid] {
            return cached
        } else {
            let path = fileManager.absolutePath("\(photoDir)/\(uuid).jpg")
            if let image = UIImage(contentsOfFile: path)  {
                imageCache[uuid] = image
                return image
            }
        }
        return nil
    }
    
    func doesImageExist(uuid uuid: String) -> Bool {
        if imageCache[uuid] != nil {
            return true
        }
        let path = fileManager.absolutePath("\(photoDir)/\(uuid).jpg")
        return fileManager.fileExistsAtPath(path)
    }
    
    func asyncLoadImage(uuid uuid: String, completion: ((image: UIImage?) -> ())) {
        if let cached = imageCache[uuid] {
            return completion(image: cached)
        }
        let path = fileManager.absolutePath("\(photoDir)/\(uuid).jpg")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            let image = UIImage(contentsOfFile: path)
            dispatch_async(dispatch_get_main_queue(), {
                if let image = image  {
                    self.imageCache[uuid] = image
                    return completion(image: image)
                } else {
                    return completion(image: nil)
                }
            })
        })
    }
    
    func saveImage(uuid uuid: String, image: UIImage) {
        fileManager.writeObject(image, toRelativePath: photoDir, fileName: "\(uuid).jpg")
        imageCache[uuid] = image
    }
    
    func deleteImage(uuid uuid: String) {
        fileManager.removeFileAtPath(fileManager.absolutePath("\(photoDir)/\(uuid).jpg"))
        imageCache.removeValueForKey(uuid)
    }
    
}


