//
//  Contact.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/20/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Contact: NSObject {

    var id: String!
    var jobContact: String?
    var email: String?
    var phone: String?
    var mobile: String?
    
    convenience init(contact: Contact) {
        self.init()
        id = contact.id
        jobContact = contact.jobContact
        email = contact.email
        phone = contact.phone
        mobile = contact.mobile
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        id = snapshot.key
        if let value = snapshot.value as? [String:Any] {
            jobContact = value["jobContact"] as? String
            email = value["email"] as? String
            phone = value["phone"] as? String
            mobile = value["mobile"] as? String
        }
    }
    
    func toAny() -> Any {
        return [
            "jobContact": jobContact ?? "",
            "email": email ?? "",
            "phone": phone ?? "",
            "mobile": mobile ?? "",
        ]
    }
}
