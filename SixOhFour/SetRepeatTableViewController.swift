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
    
    let weekdaysArray = ["S", "M", "T", "W", "T", "F", "S"]
    var weeksRepeat = 1
    var pickerHidden = true
    var weekIndex = 0
    var selectedDaysArray = Array(count: 5, repeatedValue: Array(count: 7, repeatedValue: false))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if row == 0 {
            weekLabel.text = "week"
        } else {
            weekLabel.text = "weeks"
        }
        
        weeksRepeat = row + 1
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
            return weeksRepeat + 1
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        weekIndex = indexPath.row
    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Collection View Data Source and Delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdaysArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeekdayCell", forIndexPath: indexPath) as! WeekdayCell
        
        cell.dayLabel.text = weekdaysArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WeekdayCell
        
        if !selectedDaysArray[weekIndex][indexPath.row] {
            cell.backgroundColor = UIColor.darkGrayColor()
            cell.dayLabel.textColor = UIColor.whiteColor()
            selectedDaysArray[weekIndex][indexPath.row] = true
        } else {
            cell.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
            cell.dayLabel.textColor = UIColor.blackColor()
            selectedDaysArray[weekIndex][indexPath.row] = false
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
