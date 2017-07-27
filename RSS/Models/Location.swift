//
//  Location.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/17/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Location: NSObject {
    
    var id: String = ""
    var location: String?
    var desc: String?
    var fullAddress: String?
    var latitude: Double?
    var longitude: Double?
    var placeId: String?
    
    convenience init(loc: Location) {
        self.init()
        id = loc.id
        location = loc.location
        fullAddress = loc.fullAddress
        latitude = loc.latitude
        longitude = loc.longitude
        placeId = loc.placeId
        desc = loc.desc
    }

    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        id = snapshot.key
        if let value = snapshot.value as? [String:Any] {
            fullAddress = value["address"] as? String
            location = value["location"] as? String
            latitude = value["latitude"] as? Double
            longitude = value["longitude"] as? Double
        }
    }

    func toAny() -> Any {
        return [
            "location": location ?? "",
            "address": fullAddress ?? "",
            "latitude": latitude ??  0,
            "longitude": longitude ?? 0
        ]
    }
}
