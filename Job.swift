//
//  Job.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/29/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import Foundation
import CoreData

class Job: NSManagedObject {

    @NSManaged var payRate: NSDecimalNumber
    @NSManaged var position: String
    @NSManaged var company: Company
    @NSManaged var schedule: NSManagedObject
    @NSManaged var workedShifts: NSSet

}
