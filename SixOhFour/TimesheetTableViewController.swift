//
//  TimesheetTableViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 8/14/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class TimesheetTableViewController: UITableViewController {
    
    var startDatePickerHidden = true
    var endDatePickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 5
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 60
        } else if indexPath.section == 1 && indexPath.row == 1 {
            if startDatePickerHidden {
                return 0
            } else {
                return 162
            }
        } else if indexPath.section == 1 && indexPath.row == 3 {
            if endDatePickerHidden {
                return 0
            } else {
                return 162
            }
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            togglePicker("startDate")
        } else if indexPath.section == 1 && indexPath.row == 2 {
            togglePicker("endDate")
        } else {
            togglePicker("close")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("hoursCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("earningsCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
            
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("startCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("startDateCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
            
        } else if indexPath.section == 1 && indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("endCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
            
        } else if indexPath.section == 1 && indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("endDateCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        
        } else if indexPath.section == 1 && indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        return UITableViewCell()
    }
    
    // Tableview Headers
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel.textAlignment = NSTextAlignment.Justified
        
        if section == 1 {
            header.textLabel.text = "TIMESHEET"
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        } else {
            return 35
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func togglePicker(picker: String) {
        if picker == "startDate" {
            startDatePickerHidden = !startDatePickerHidden
            endDatePickerHidden = true
        } else if picker == "endDate" {
            endDatePickerHidden = !endDatePickerHidden
            startDatePickerHidden = true
        } else {
            // Close datepickers
            startDatePickerHidden = true
            endDatePickerHidden = true
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
