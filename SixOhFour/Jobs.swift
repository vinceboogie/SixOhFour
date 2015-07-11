//
//  Jobs.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/23/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import Foundation
import CoreData
@objc(Jobs)

class Jobs: NSManagedObject {
    
    @NSManaged var jobName: String
    @NSManaged var jobPay: String
    @NSManaged var jobPosition: String
    @NSManaged var jobColor: String
    
    //INTIALIZED NEW JOBs. Just needed until Vince's CoreData get inputed to give value
    
    func getJobColor() -> UIColor {
    
        if jobColor == "Red" {
            return UIColor.redColor()
        } else if jobColor == "Blue" {
            return UIColor.blueColor()
        } else if jobColor == "Green" {
            return UIColor.greenColor()
        } else if jobColor == "Yellow" {
            return UIColor.yellowColor()
        } else if jobColor == "Purple" {
            return UIColor.purpleColor()
        } else {
            return UIColor.blackColor()
        }
    }
}