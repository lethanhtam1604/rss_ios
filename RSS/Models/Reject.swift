//
//  Reject.swift
//  RSS
//
//  Created by Thanh-Tam Le on 5/5/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Reject: NSObject {
    
    var reason: String?
    var seen: Bool?
    
    convenience init(reject: Reject) {
        self.init()
        reason = reject.reason
        seen = reject.seen
        
        
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        if let value = snapshot.value as? [String:Any] {
            reason = value["reason"] as? String
            seen = value["seen"] as? Bool
        }
    }
    
    func toAny() -> Any {
        return [
            "reason": reason ?? "",
            "seen": seen ?? true
        ]
    }
}
