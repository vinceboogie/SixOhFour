//
//  ClockIn_EndedBreakCell.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 7/11/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class ClockIn_EndedBreakCell: UITableViewCell {

    
    @IBOutlet weak var timelogCommentLabel: UILabel!
    @IBOutlet weak var timelogBreakDurationLabel: UILabel!
    @IBOutlet weak var timelogTimestampLabel: UILabel!
    @IBOutlet weak var timelogTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
