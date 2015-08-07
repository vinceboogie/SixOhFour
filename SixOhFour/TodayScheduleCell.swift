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
    @IBOutlet weak var nextDayLabel: UILabel!
    
    var shift: ScheduledShift! {
        didSet {
            jobColorView.color = shift.job.color.getColor
            
            jobNameLabel.text = shift.job.company.name
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .NoStyle
            formatter.timeStyle = .ShortStyle
            
            shiftTimeLabel.text = "\(formatter.stringFromDate(shift.startTime)) - \(formatter.stringFromDate(shift.endTime))"
            
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .NoStyle
 
            let start = "\(formatter.stringFromDate(shift.startTime))"
            let end = "\(formatter.stringFromDate(shift.endTime))"
            
            
            if start == end {
                nextDayLabel.hidden = true
            } else {
                nextDayLabel.hidden = false
            }
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
