//
//  Message.swift
//  RSS
//
//  Created by Thanh-Tam Le on 5/11/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class Message: NSObject {

    var sound = true
    var body: String?
    var title: String?
    
    convenience init(message: Message) {
        self.init()
        sound = message.sound
        body = message.body
        title = message.title
    }
    
    func toAny() -> Any {
        return [
            "sound": sound,
            "body": body ?? "",
            "title": title ?? ""
        ]
    }
}
