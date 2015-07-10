//
//  TimeLogs.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 7/9/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import Foundation
import CoreData
@objc(TimeLogs)

class TimeLogs: NSManagedObject {
    
    @NSManaged var timelogComment: String
    @NSManaged var timelogTitle: String
    @NSManaged var timelogTimestamp: String
    @NSManaged var timelogJob: String
    
}