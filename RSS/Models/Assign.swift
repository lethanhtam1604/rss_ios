//
//  Assign.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/26/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Assign: NSObject {
    
    var staffId: String?
    var acceptanceDate: String?
    
    convenience init(assign: Assign) {
        self.init()
        staffId = assign.staffId
        acceptanceDate = assign.acceptanceDate
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        if let value = snapshot.value as? [String:Any] {
            staffId = value["staffId"] as? String
            acceptanceDate = value["acceptanceDate"] as? String
        }
    }
    
    func toAny() -> Any {
        return [
            "staffId": staffId ?? "",
            "acceptanceDate": acceptanceDate ?? ""
        ]
    }
}
