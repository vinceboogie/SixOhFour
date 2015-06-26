//
//  Jobs.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/23/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import Foundation
import CoreData
@objc(Jobs)

class Jobs: NSManagedObject {
    
    @NSManaged var job: String
    @NSManaged var pay: String
    @NSManaged var position: String
    
}