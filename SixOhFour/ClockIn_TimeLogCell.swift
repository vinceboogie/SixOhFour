//
//  ClockIn_TimeLogCell.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 7/9/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class ClockIn_TimeLogCell: UITableViewCell {

    @IBOutlet weak var timelogCommentLabel: UILabel!
    @IBOutlet weak var timelogTimestampLabel: UILabel!
    @IBOutlet weak var timelogTitleLabel: UILabel!
    
    var timelogEntry: Timelog! {
        didSet {
//            var dateFormatter = NSDateFormatter( )
//            timelogTimestampLabel.text = timelogEntry.time
//            timelogTitleLabel.text = timelogEntry.type
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
