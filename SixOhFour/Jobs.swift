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
        
        return UIColor.redColor()
    
//        if jobColor == "red" {
//            return UIColor.redColor()
//        } else if jobColor == "blue" {
//            return UIColor.blueColor()
//        } else if jobColor == "green" {
//            return UIColor.greenColor()
//        } else {
//            return UIColor.blackColor()
//        }
    }
}