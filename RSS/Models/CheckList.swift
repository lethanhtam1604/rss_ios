//
//  CheckList.swift
//  RSS
//
//  Created by Thanh-Tam Le on 5/8/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class CheckList: NSObject {
    
    var photoBefore = [ImageUrl]()
    var summary: String?
    var narrativeOfRepairs: String?
    
    var followUpRequired: Bool?
    var followUpDescription: String?
    var partNeeded: Bool?
    var partDescription: String?
    var signature: String?
    var signatureLocal: UIImage?

    var photoAfter = [ImageUrl]()
    var parts = [Part]()

    convenience init(checkList: CheckList) {
        self.init()
        summary = checkList.summary
        narrativeOfRepairs = checkList.narrativeOfRepairs
        followUpDescription = checkList.followUpDescription
        partDescription = checkList.partDescription

        photoBefore = []
        photoBefore.append(contentsOf: checkList.photoBefore)
        
        photoAfter = []
        photoAfter.append(contentsOf: checkList.photoAfter)
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        if let value = snapshot.value as? [String:Any] {
            summary = value["summary"] as? String
            narrativeOfRepairs = value["narrativeOfRepairs"] as? String
            followUpDescription = value["followUpDescription"] as? String
            partDescription = value["partDescription"] as? String
            followUpRequired = value["followUpRequired"] as? Bool
            partNeeded = value["partNeeded"] as? Bool
            signature = value["signature"] as? String

            let photoBeforeSnapshot = snapshot.childSnapshot(forPath: "photoBefore")
            if let images = photoBeforeSnapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in images {
                    let imageUrl = ImageUrl(snap)
                    self.photoBefore.append(imageUrl)
                }
            }
            
            let photoAfterSnapshot = snapshot.childSnapshot(forPath: "photoAfter")
            if let images = photoAfterSnapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in images {
                    let imageUrl = ImageUrl(snap)
                    self.photoAfter.append(imageUrl)
                }
            }
            
            let partSnapshot = snapshot.childSnapshot(forPath: "parts")
            if let images = partSnapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in images {
                    let part = Part(snap)
                    self.parts.append(part)
                }
            }
        }
    }
    
    func toAny() -> Any {
        
        var photoBeforeArray = [Any]()
        
        for image in photoBefore {
            photoBeforeArray.append(image.toAny())
        }
        
        var photoAfterArray = [Any]()
        
        for image in photoAfter {
            photoAfterArray.append(image.toAny())
        }
        
        var partArray = [Any]()
        
        for part in parts {
            partArray.append(part.toAny())
        }
        
        return [
            "photoBefore": photoBeforeArray,
            "summary": summary ?? "",
            "narrativeOfRepairs": narrativeOfRepairs ?? "",
            "photoAfter": photoAfterArray,
            "followUpRequired": followUpRequired ?? false,
            "followUpDescription": followUpDescription ?? "",
            "partNeeded": partNeeded ?? false,
            "partDescription": partDescription ?? "",
            "signature": signature ?? "",
            "parts": partArray
        ]
    }
}
