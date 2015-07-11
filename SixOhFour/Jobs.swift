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
    
    @NSManaged var jobName: String
    @NSManaged var jobPay: String
    @NSManaged var jobPosition: String
    
    //INTIALIZED NEW JOBs. Just needed until Vince's CoreData get inputed to give value
}