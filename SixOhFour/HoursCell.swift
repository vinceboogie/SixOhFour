//
//  HoursCell.swift
//  SixOhFour
//
//  Created by vinceboogie on 8/20/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class HoursCell: UITableViewCell {
    
    @IBOutlet weak var regularHoursLabel: UILabel!
    @IBOutlet weak var overtimeHoursLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
