//
//  Reminders.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/29/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import Foundation
import CoreData

class Reminders: NSManagedObject {

    @NSManaged var alert: NSNumber
    @NSManaged var enableAlert: NSNumber
    @NSManaged var enableReminder: NSNumber
    @NSManaged var enableReminder2: NSNumber
    @NSManaged var reminder: NSNumber
    @NSManaged var reminder2: NSNumber

}
