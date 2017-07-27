//
//  Accept.swift
//  RSS
//
//  Created by Thanh-Tam Le on 5/5/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Accept: NSObject {
    
    var expectedStartDate: String?
    var expectedStartTime: String?
    
    var reason: String?
    var seen: Bool?
    
    convenience init(accept: Accept) {
        self.init()
        expectedStartDate = accept.expectedStartDate
        expectedStartTime = accept.expectedStartTime
        reason = accept.reason
        seen = accept.seen
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        if let value = snapshot.value as? [String:Any] {
            expectedStartDate = value["expectedStartDate"] as? String
            expectedStartTime = value["expectedStartTime"] as? String
            reason = value["reason"] as? String
            seen = value["seen"] as? Bool
        }
    }
    
    func toAny() -> Any {
        return [
            "expectedStartDate": expectedStartDate ?? "",
            "expectedStartTime": expectedStartTime ?? "",
            "reason": reason ?? "",
            "seen": seen ?? true
        ]
    }
}
