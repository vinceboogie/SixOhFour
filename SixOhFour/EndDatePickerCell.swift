//
//  EndDatePickerCell.swift
//  SixOhFour
//
//  Created by vinceboogie on 8/20/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class EndDatePickerCell: UITableViewCell {

    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBAction func endDatePickerValue(sender: AnyObject) {
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
