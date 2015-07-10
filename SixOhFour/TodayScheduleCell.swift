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
    
    var shift: Shift! {
        didSet {
            jobColorView.color = shift.color!
            jobNameLabel.text = shift.name
            shiftTimeLabel.text = shift.shiftTime
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
