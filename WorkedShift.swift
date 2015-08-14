//
//  WorkedShift.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/29/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import Foundation
import CoreData
@objc(WorkedShift)

class WorkedShift: NSManagedObject {

    @NSManaged var duration: Double
    @NSManaged var source: String
    @NSManaged var status: NSNumber
    @NSManaged var job: Job
    @NSManaged var timelogs: NSSet
    

}
