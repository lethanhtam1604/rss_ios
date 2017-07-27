//
//  Client.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/20/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Client: NSObject {

    var id: String = ""
    var name: String?
    
    var location = Location()
    var contacts = [Contact]()
    
    convenience init(client: Client) {
        self.init()
        id = client.id
        name = client.name
        location = client.location
        
        contacts = []
        contacts.append(contentsOf: client.contacts)
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        id = snapshot.key
        if let value = snapshot.value as? [String:Any] {
            name = value["name"] as? String
            
            let locationSnapshot = snapshot.childSnapshot(forPath: "location")
            if locationSnapshot.exists() {
                location = Location(locationSnapshot)
            }
            
            let contactSnapshot = snapshot.childSnapshot(forPath: "contacts")
            if let contacts = contactSnapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in contacts {
                    let contact = Contact(snap)
                    self.contacts.append(contact)
                }
            }
        }
    }
    
    func toAny() -> Any {
        var contactArray = [Any]()
        
        for contact in contacts {
            contactArray.append(contact.toAny())
        }

        return [
            "name": name ?? "",
            "location": location.toAny(),
            "contacts": contactArray,
        ]
    }
}
