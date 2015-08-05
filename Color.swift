//
//  Color.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/29/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import Foundation
import CoreData
@objc(Color)


class Color: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var isSelected: NSNumber
    @NSManaged var job: Job

}

extension Color {
    var getColor: UIColor {
        get {
            
            switch(name) {
            case "Red":
                return UIColor.redColor()
            case "Blue":
                return UIColor.blueColor()
            case "Green":
                return UIColor.greenColor()
            case "Yellow":
                return UIColor.yellowColor()
            case "Purple":
                return UIColor.purpleColor()
            default:
                return UIColor.blackColor()
            }
        }
    }
}
