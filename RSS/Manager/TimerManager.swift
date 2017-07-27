//
//  TimerManager.swift
//  RSS
//
//  Created by Thanh-Tam Le on 5/10/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class TimerManager {
    private static var sharedInstance: TimerManager!
    
    var timer: Timer?
    
    static func getInstance() -> TimerManager {
        if(sharedInstance == nil) {
            sharedInstance = TimerManager()
        }
        return sharedInstance
    }
    
    private init() {
        
    }
}
