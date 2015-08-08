//
//  SetRepeatTableViewController.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/16/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class SetRepeatTableViewController: UITableViewController {

    @IBOutlet weak var repeatPicker: UIPickerView!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet var collectionView: [UICollectionView]!
    
    var doneButton: UIBarButtonItem!
    var repeatSettings: RepeatSettings!
    
    var repeatPickerHidden = true
    var frequencyPickerHidden = true

    let weekdaysArray = ["S", "M", "T", "W", "T", "F", "S"]
    let repeatTypes = ["Never", "Weekly", "Monthly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repeatLabel.text = repeatSettings.type
        setFrequencyLabelText(repeatSettings.frequency)
        
        doneButton = UIBarButtonItem(title:"Done", style: .Plain, target: self, action: "setRepeat")
        self.navigationItem.rightBarButtonItem = self.doneButton
    
        var row = 0
        
        if repeatSettings.type == "Weekly" {
            row = 1
        } else if repeatSettings.type == "Monthly" {
            row = 2
        }
        
        repeatPicker.selectRow(row, inComponent: 0, animated: true)
        frequencyPicker.selectRow(repeatSettings.frequency-1, inComponent: 0, animated: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Class Functions
    
    func setFrequencyLabelText(row: Int) {
        var str = "\(row) "
        
        if repeatSettings.type == "Weekly" {
            // Max value for weeks is 4
            if row > 4 {
                str = "4 "
            }
            
            str += "week"
        } else if repeatSettings.type == "Monthly" {
            str += "month"
        }
        
        if row > 1 {
            str += "s"
        }
        
        frequencyLabel.text = str
    }
    
    func setRepeat() {
        if repeatSettings.type == "Never" {
            repeatSettings = RepeatSettings()
        }
        
        self.performSegueWithIdentifier("unwindAfterSetRepeat", sender: self)
    }
    
    func togglePicker(picker: String) {
        switch(picker) {
        case "repeatPicker":
            repeatPickerHidden = !repeatPickerHidden
            frequencyPickerHidden = true
        case "frequencyPicker":
            frequencyPickerHidden = !frequencyPickerHidden
            repeatPickerHidden = true
        default:
            repeatPickerHidden = true
            frequencyPickerHidden = true
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return repeatSettings.weeksToRepeat + 1 // Add 1 to account for the first cell containing the label
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            togglePicker("repeatPicker")
        } else if indexPath.section == 0 && indexPath.row == 2 {
            togglePicker("frequencyPicker")
        } else {
            togglePicker("close")
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if repeatPickerHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        }
        
        if frequencyPickerHidden && indexPath.section == 0 && indexPath.row == 3 {
            return 0
        }
        
        if repeatSettings.type == "Never" && indexPath.section == 0 && indexPath.row == 2 {
            return 0
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
}


// MARK: - Picker View Data Source and Delegate

extension SetRepeatTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch(pickerView) {
        case repeatPicker:
            return 1
        case frequencyPicker:
            return 2
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(pickerView) {
        case repeatPicker:
            return 3
        case frequencyPicker:
            if component == 0 {
                if repeatSettings.type == "Weekly" {
                    return 4
                } else if repeatSettings.type == "Monthly" {
                    return 12
                }
            }
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch(pickerView) {
        case repeatPicker:
            return repeatTypes[row]
        case frequencyPicker:
            if component == 0 {
                return "\(row+1)"
            } else {
                if repeatSettings.type == "Weekly" {
                    if pickerView.selectedRowInComponent(0) > 0 {
                        return "weeks"
                    } else {
                        return "week"
                    }
                } else if repeatSettings.type == "Monthly" {
                    if pickerView.selectedRowInComponent(0) > 0  {
                        return "months"
                    } else {
                        return "month"
                    }
                } else {
                    return ""
                }
            }
        default:
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(pickerView) {
        case repeatPicker:
            repeatLabel.text = repeatTypes[row]
            repeatSettings.type = repeatTypes[row]
            
            setFrequencyLabelText(frequencyPicker.selectedRowInComponent(0)+1)
            
        case frequencyPicker:
            setFrequencyLabelText(row+1)
            repeatSettings.frequency = row+1
        default: ()
            
        }
        
        frequencyPicker.reloadAllComponents()
        
        
        //        // TODO: Implement weekly and monthly view
        //        var previous = repeatSettings.weeksToRepeat
        //        var current = row + 1
        //
        //        repeatSettings.weeksToRepeat = current
        //
        //
        //        println(previous)
        //        println(current)
        //
        //        if current > previous {
        //            for x in previous...row {
        //                for y in 0...6 {
        //                    repeatSettings.selectedDaysArray[x][y] = repeatSettings.selectedDaysArray[x-1][y]
        //                }
        //                collectionView[x].reloadData()
        //            }
        //        }
        //
        //                // Test
        //                for x in 0...4 {
        //                    for y in 0...6 {
        //                        print(repeatSettings.selectedDaysArray[x][y])
        //                        print("\t")
        //                    }
        //                    println("")
        //                }
        //                println("")
        //
        //        // Reset the selected days for weeks not displayed
        //        if repeatSettings.weeksToRepeat < 5 {
        //            for x in repeatSettings.weeksToRepeat...4 {
        //                for y in 0...6 {
        //                    repeatSettings.selectedDaysArray[x][y] = false
        //                }
        //            }
        //        }
        
        tableView.reloadData()
    }
}


// MARK: - Collection View Data Source and Delegate

extension SetRepeatTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdaysArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeekDayCell", forIndexPath: indexPath) as! WeekDayCollectionViewCell
        
        var weekIndex = collectionView.tag
        
        if repeatSettings.selectedDaysArray[weekIndex][indexPath.row]{
            cell.backgroundColor = .colorFromCode(0x1D62F0)
            cell.dayLabel.textColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.dayLabel.textColor = UIColor.blackColor()
        }
        
        cell.dayLabel.font = UIFont.boldSystemFontOfSize(12.0)
        cell.dayLabel.text = weekdaysArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WeekDayCollectionViewCell
        
        var weekIndex = collectionView.tag
        
        if repeatSettings.selectedDaysArray[weekIndex][indexPath.row] == false{
            cell.backgroundColor = .colorFromCode(0x1D62F0)
            cell.dayLabel.textColor = UIColor.whiteColor()
            
            repeatSettings.selectedDaysArray[weekIndex][indexPath.row] = true
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.dayLabel.textColor = UIColor.blackColor()
            
            repeatSettings.selectedDaysArray[weekIndex][indexPath.row] = false
        }
    }
}

