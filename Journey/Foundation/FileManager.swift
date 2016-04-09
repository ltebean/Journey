//
//  FileManager.swift
//  Noah
//
//  Created by ltebean on 15/10/27.
//  Copyright © 2015年 Glow. All rights reserved.
//

import Foundation
import UIKit

public class FileManager: NSObject {
    
    public static let sharedInstance = FileManager()
    
    let fileManager = NSFileManager.defaultManager()
    let documentPath = try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true).path!
    
    public func absolutePath(path: String) -> String {
        return documentPath + "/" + path
    }
    
    public func fileExistsAtRelativePath(path: String) -> Bool {
        return fileManager.fileExistsAtPath(absolutePath(path))
    }
    
    public func fileExistsAtPath(path: String) -> Bool {
        return fileManager.fileExistsAtPath(path)
    }
    
    public func writeObject(object: NSObject, toRelativePath relativePath: String, fileName: String) -> Bool {
        return writeObject(object, toPath: absolutePath(relativePath), fileName:fileName)
    }
    
    public func removeFileAtPath(path: String) {
        do {
            try fileManager.removeItemAtPath(path)
        } catch {
            return
        }
    }
    
    public func writeObject(object: NSObject, toPath path: String, fileName: String) -> Bool {
        do {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return false
        }
        let finalPath = "\(path)/\(fileName)"
        if let object = object as? NSArray {
            return object.writeToFile(finalPath, atomically: true)
        }
        else if let object = object as? NSDictionary {
            return object.writeToFile(finalPath, atomically: true)
        }
        else if let object = object as? UIImage {
            return (UIImageJPEGRepresentation(object, 0.8)?.writeToFile(finalPath, atomically: true))!
        }
        return false
    }
}
