//
//  RepeatWeekly.swift
//  SixOhFour
//
//  Created by jemsomniac on 8/12/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class RepeatWeekly: RepeatSettings {
    var daysToRepeat = Array<Array<Bool>>()
    
    override init() {
        super.init()
        
        repeatEvery = 1
        daysToRepeat = Array(count: 4, repeatedValue: Array(count: 7, repeatedValue: false))
    }
}
