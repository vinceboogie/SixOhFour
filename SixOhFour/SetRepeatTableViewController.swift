//
//  SetRepeatTableViewController.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/16/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class SetRepeatTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var repeatPicker: UIPickerView!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet var collectionView: [UICollectionView]!

    
    let weekdaysArray = ["S", "M", "T", "W", "T", "F", "S"]
    
    var doneButton: UIBarButtonItem!
    var pickerHidden = true
    var repeatSettings: RepeatSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton = UIBarButtonItem(title:"Done", style: .Plain, target: self, action: "setRepeat")
        self.navigationItem.rightBarButtonItem = self.doneButton
        
        if repeatSettings.enabled {
            pickerHidden = false
            repeatSwitch.on = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        var row = repeatSettings.weeksToRepeat - 1 // subtract 1 since row index starts at 0
        repeatPicker.selectRow(row, inComponent: 0, animated: true)
        
        setWeekLabelText(row)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Class Functions
    
    func setWeekLabelText(row: Int) {
        if row == 0 {
            weekLabel.text = "week"
        } else {
            weekLabel.text = "weeks"
        }
    }
    
    func setRepeat() {
        if repeatSwitch.on {
            repeatSettings.enabled = true
        } else {
            repeatSettings = RepeatSettings()
        }
        self.performSegueWithIdentifier("unwindAfterSetRepeat", sender: self)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func toggleSwitch(sender: AnyObject) {
        if repeatSwitch.on {
            pickerHidden = false
        } else {
            pickerHidden = true
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Repeat Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5 // Maximum repeat is 5 weeks
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(row + 1)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setWeekLabelText(row)
        
        var previous = repeatSettings.weeksToRepeat
        var current = row + 1

        repeatSettings.weeksToRepeat = current

        
        println(previous)
        println(current)
        
        if current > previous {
            for x in previous...row {
                for y in 0...6 {
                    repeatSettings.selectedDaysArray[x][y] = repeatSettings.selectedDaysArray[x-1][y]
                }
                collectionView[x].reloadData()
            }
        }
        
                // Test
                for x in 0...4 {
                    for y in 0...6 {
                        print(repeatSettings.selectedDaysArray[x][y])
                        print("\t")
                    }
                    println("")
                }
                println("")
        
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
        
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return repeatSettings.weeksToRepeat + 1 // Add 1 to account for the first cell containing the label
        }
    }
        
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if pickerHidden {
            if indexPath.section == 0 && indexPath.row == 0 {
                return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            } else {
                return 0
            }
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    // MARK: - Collection View Data Source and Delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdaysArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeekDayCell", forIndexPath: indexPath) as! WeekDayCollectionViewCell
        
        var weekIndex = collectionView.tag
        
        if repeatSettings.selectedDaysArray[weekIndex][indexPath.row]{
            cell.backgroundColor = UIColor.darkGrayColor()
            cell.dayLabel.textColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.dayLabel.textColor = UIColor.blackColor()
        }
        
        cell.dayLabel.text = weekdaysArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WeekDayCollectionViewCell
        
        var weekIndex = collectionView.tag
        
        if repeatSettings.selectedDaysArray[weekIndex][indexPath.row] == false{
            cell.backgroundColor = UIColor.darkGrayColor()
            cell.dayLabel.textColor = UIColor.whiteColor()

            repeatSettings.selectedDaysArray[weekIndex][indexPath.row] = true
        } else {
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.dayLabel.textColor = UIColor.blackColor()
            
            repeatSettings.selectedDaysArray[weekIndex][indexPath.row] = false
        }
        
//        // Test
//        for x in 0...4 {
//            for y in 0...6 {
//                print(repeatSettings.selectedDaysArray[x][y])
//                print("\t")
//            }
//            println("")
//        }
//        println("")

    }
    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
    

}
