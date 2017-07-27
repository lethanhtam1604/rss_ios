//
//  Expenses.swift
//  RSS
//
//  Created by Thanh-Tam Le on 5/7/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Expenses: NSObject {

    var descriptionExpenses: String?
    var imageUrl = [ImageUrl]()

    convenience init(expenses: Expenses) {
        self.init()
        descriptionExpenses = expenses.descriptionExpenses
        
        imageUrl = []
        imageUrl.append(contentsOf: expenses.imageUrl)
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        if let value = snapshot.value as? [String:Any] {
            descriptionExpenses = value["descriptionExpenses"] as? String
            
            let imageSnapshot = snapshot.childSnapshot(forPath: "images")
            if let images = imageSnapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in images {
                    let imageUrl = ImageUrl(snap)
                    self.imageUrl.append(imageUrl)
                }
            }
        }
    }
    
    func toAny() -> Any {
        
        var imageArray = [Any]()
        
        for image in imageUrl {
            imageArray.append(image.toAny())
        }
        
        return [
            "descriptionExpenses": descriptionExpenses ?? "",
            "images": imageArray
        ]
    }
}
