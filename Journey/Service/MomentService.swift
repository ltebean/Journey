//
//  MomentService.swift
//  Journey
//
//  Created by ltebean on 16/2/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import Foundation
import RealmSwift

class MomentService {
    
    enum Event: String {
        case MomentUpdated
    }
    
    static let sharedInstance = MomentService()
    
    let realm = try! Realm()
    let photoService = PhotoService.sharedInstance
    
    func loadAllMoments() -> [Moment] {
        let result: Results<Moment> = realm.objects(Moment).sorted("date")
        var data: [Moment] = []
        for r in result {
            data.append(r)
        }
        if data.count > 0 {
            return data
        } else {
            return getDemoData()
        }
    }
    
    private func getDemoData() -> [Moment] {
        let moment = Moment()
        saveMoment(moment, image: R.image.momentDemo()!, write: { moment in
            moment.title = "Welcome"
//            moment.title = "Switzerland"
            moment.date = NSDate()
            moment.text = "You can pull down to hide the cards, rotate the screen to view the full photo."
//            moment.text = "What a beautiful and gorgeous way to see the Swiss Alps!! The views from the top of Mount Rigi where breath-taking and exploring the town was absolutely amazing."
        })
        return [moment]
    }
    
    func saveMoment(moment: Moment, image: UIImage?, write: (monent: Moment) -> ()) {
        guard !moment.invalidated else {
            return
        }
        try! realm.write {
            write(monent: moment)
            if let image = image {
                photoService.deleteImage(uuid: moment.photoUuid)
                moment.photoUuid = NSUUID().UUIDString
                photoService.saveImage(uuid: moment.photoUuid, image: image)
            }
            realm.add(moment, update: true)
        }
    }
    

    
    func deleteMoment(moment: Moment) {
        guard !moment.invalidated else {
            return
        }
        try! realm.write {
            photoService.deleteImage(uuid: moment.photoUuid)
            realm.delete(moment)
        }
    }
}
    