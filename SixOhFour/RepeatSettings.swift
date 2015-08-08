//
//  RepeatSettings.swift
//  SixOhFour
//
//  Created by jemsomniac on 8/12/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class RepeatSettings: NSObject {
    var type = "Never" // Accepted values: Never, Weekly, Monthly
    var repeatEvery = 0
    var daySelectedIndex = 0 // Fail safe default is Sunday
    var endDate: NSDate!
}
