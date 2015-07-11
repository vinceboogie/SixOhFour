//
//  ClockIn_JobsCell.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 7/9/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class ClockIn_JobsCell: UITableViewCell {
    
    @IBOutlet weak var clockInJobLabel: UILabel!
    
//    var locations  = [Jobs]() // Where Locations = your NSManaged Class
//    
//    var fetchRequest = NSFetchRequest(entityName: "Jobs")
//    
//    var error:NSError?
    
    //let fetchdResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
    
    //       locations = context.executeFetchRequest(fetchRequest, error: nil) as [Jobs]
    
    
    var jobtest : Jobs! {
        didSet {
            clockInJobLabel.text = jobtest.jobName
        }
    }
    
    
    //        for locations in Jobs() {
    //            println(locations.job)
    //        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
