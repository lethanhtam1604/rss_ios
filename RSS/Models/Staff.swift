//
//  Staff.swift
//  RSS
//
//  Created by Thanh-Tam Le on 5/3/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Staff: NSObject {

    var id: String = ""

    convenience init(staff: Staff) {
        self.init()
        id = staff.id
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        id = snapshot.key
    }
}
