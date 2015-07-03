//
//  Shift.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/2/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class Shift: NSObject {
    
    var color: UIColor?
    var name: String?
    var shiftTime: String?
    
    init(dictionary: NSDictionary) {
        color = dictionary["color"] as? UIColor
        name = dictionary["name"] as? String
        shiftTime = dictionary["shiftTime"] as? String
        
    }
    
//    func createDummySchedule() -> [Shift] {
//        var schedule = [Shift]()
//        
//        schedule.append(Shift(dictionary: ["color": UIColor.redColor(), "name": "Red Garage", "shiftTime": "0800-2200"]))
//        schedule.append(Shift(dictionary:["color": UIColor.greenColor(), "name": "Air New Zealand", "shiftTime": "1800-2200"]))
//        schedule.append(Shift(dictionary:["color": UIColor.blueColor(), "name": "Golden State Warriors", "shiftTime": "1930-2230"]))
//        
//        return schedule
//    }
}
