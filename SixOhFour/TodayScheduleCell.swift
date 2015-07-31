//
//  TodayScheduleCell.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/2/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class TodayScheduleCell: UITableViewCell {

    @IBOutlet weak var jobColorView: JobColorView!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var shiftTimeLabel: UILabel!
    
    var shift: ScheduledShift! {
        didSet {
            var jc = JobColor()
            jobColorView.color = jc.getJobColor(shift.job.color.name)
            
            jobNameLabel.text = shift.job.company.name
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .NoStyle
            formatter.timeStyle = .ShortStyle
            
            shiftTimeLabel.text = "\(formatter.stringFromDate(shift.startTime)) - \(formatter.stringFromDate(shift.endTime))"
            
            
            println(shift.job.color.name)
            println(shift.job.company.name)
            println(shiftTimeLabel.text)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
