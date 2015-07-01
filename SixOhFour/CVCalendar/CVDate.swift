//
//  CVDate.swift
//  CVCalendar
//
//  Created by Мак-ПК on 12/31/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

class CVDate: NSObject {
    private var date: NSDate?
    var year: Int?
    var month: Int?
    var week: Int?
    var day: Int?
    
    init(date: NSDate) {
        super.init()
        
        let calendarManager = CVCalendarManager.sharedManager
        
        self.date = date
        
        self.year = calendarManager.dateRange(date).year
        self.month = calendarManager.dateRange(date).month
        self.day = calendarManager.dateRange(date).day
    }
    
    init(day: Int, month: Int, week: Int, year: Int) {
        super.init()
        
        self.year = year
        self.month = month
        self.week = week
        self.day = day
    }
    
    func displayMonth() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        let month = dateFormatter.stringFromDate(self.date!)
        
            return "\(month)"
    }
    
    func displayMonthYear() -> String {
        let month = displayMonth()
        
        return "\(month) \(self.year!)"
    }
}
