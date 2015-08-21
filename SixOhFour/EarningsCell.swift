//
//  EarningsCell.swift
//  SixOhFour
//
//  Created by vinceboogie on 8/20/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class EarningsCell: UITableViewCell {
    
    @IBOutlet weak var earningsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        earningsLabel.text = "$1337"
        
        if earningsLabel == nil {
            println("PML")
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
