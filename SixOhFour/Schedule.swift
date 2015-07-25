//
//  Schedule.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/24/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class Schedule: NSObject {
    
    var job: Jobs!
    var startShift: NSDate!
    var endShift: NSDate!
    var reminder: Int! 
   
    init(job: Jobs, startShift: NSDate, endShift: NSDate, reminder: Int) {
        self.job = job
        self.startShift = startShift
        self.endShift = endShift
        self.reminder = reminder
    }
}
