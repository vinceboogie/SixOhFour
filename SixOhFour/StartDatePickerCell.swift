//
//  StartDatePickerCell.swift
//  SixOhFour
//
//  Created by vinceboogie on 8/20/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class StartDatePickerCell: UITableViewCell {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBAction func startDatePickerValue(sender: AnyObject) {

    }

    var startDate: NSDate!
    var endDate: NSDate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let dateComponents = calendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay, fromDate: endDate)
        startDate = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -6, toDate: endDate, options: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func datePickerChanged(label: UILabel, datePicker: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        label.text = dateFormatter.stringFromDate(datePicker.date)
        
        if datePicker == startDatePicker {
            if datePicker.date.compare(endDatePicker.date) == NSComparisonResult.OrderedDescending {
                endDetailLabel.text = label.text
                endDatePicker.date = datePicker.date
            } else {
                endDetailLabel.text = dateFormatter.stringFromDate(endDatePicker.date)
            }
            
            startDate = datePicker.date
            endDate = endDatePicker.date
        }
        
        if datePicker == endDatePicker {
            if datePicker.date.compare(startDatePicker.date) == NSComparisonResult.OrderedAscending {
                startDetailLabel.text = label.text
                startDatePicker.date = datePicker.date
            } else {
                startDetailLabel.text = dateFormatter.stringFromDate(startDatePicker.date)
            }
            endDate = datePicker.date
            startDate = startDatePicker.date
        }
        
    }

}
