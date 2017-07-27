//
//  User.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/17/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class User: NSObject {
    
    var id: String = ""
    var email: String!
    var name: String?
    var lastName: String?
    var businessName: String?
    var phone: String?
    var contractor: Bool?
    var type: Int? //0: user, 1: admin
    var adminId: String?
    var totalBadge: Int?
    var location = Location()
    
    convenience init(user: User) {
        self.init()
        id = user.id
        name = user.name
        lastName = user.lastName
        email = user.email
        businessName = user.businessName
        phone = user.phone
        location = user.location
        contractor = user.contractor
        type = user.type
        adminId = user.adminId
        totalBadge = user.totalBadge
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        id = snapshot.key
        if let snapshotValue = snapshot.value as? [String:Any] {
            name = snapshotValue["name"] as? String
            lastName = snapshotValue["lastName"] as? String
            email = snapshotValue["email"] as? String
            businessName = snapshotValue["businessName"] as? String
            phone = snapshotValue["phone"] as? String
            contractor = snapshotValue["contractor"] as? Bool
            type = snapshotValue["type"] as? Int
            adminId = snapshotValue["adminId"] as? String
            totalBadge = snapshotValue["totalBadge"] as? Int

            let locationSnapshot = snapshot.childSnapshot(forPath: "location")
            if locationSnapshot.exists() {
                location = Location(locationSnapshot)
            }
        }
    }
    
    func toAny() -> Any {
        return [
            "name": name ?? "",
            "lastName": lastName ?? "",
            "email": email,
            "businessName": businessName ?? "",
            "phone": phone ?? "",
            "location": location.toAny(),
            "contractor": contractor ?? false,
            "type": type ?? 1,
            "adminId": adminId ?? "",
            "totalBadge": totalBadge ?? 0
        ]
    }
}

