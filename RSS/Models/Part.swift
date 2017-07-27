//
//  Part.swift
//  RSS
//
//  Created by Thanh-Tam Le on 5/8/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Part: NSObject {
    
    var name: String?
    var partDescription: String?
    var quantity: Int?
    
    convenience init(part: Part) {
        self.init()
        name = part.name
        partDescription = part.partDescription
        quantity = part.quantity
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        if let value = snapshot.value as? [String:Any] {
            name = value["name"] as? String
            partDescription = value["description"] as? String
            quantity = value["quantity"] as? Int
        }
    }
    
    func toAny() -> Any {
        return [
            "name": name ?? "",
            "description": partDescription ?? "",
            "quantity": quantity ?? 0
        ]
    }
}
