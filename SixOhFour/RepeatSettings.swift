//
//  RepeatSettings.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/16/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

struct RepeatSettings {
    var enabled = false
    var weeksToRepeat = 1 // Defaults to 1 week
    var selectedDaysArray = Array(count: 5, repeatedValue: Array(count: 7, repeatedValue: false))
    var daySelectedIndex = 0 // Fail safe default is Sunday
    var startDate: NSDate!
}
