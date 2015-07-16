//
//  EndRepeatTableViewController.swift
//  SixOhFour
//
//  Created by Jem on 7/22/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class EndRepeatTableViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var neverCell: UITableViewCell!
    @IBOutlet weak var onDateCell: UITableViewCell!
    
    var endRepeat: String!
    var doneButton: UIBarButtonItem!
    var backButtonTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if endRepeat == "Never" {
            neverCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            neverCell.selected = true
        } else {
            onDateCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            onDateCell.selected = true
        }
        
        doneButton = UIBarButtonItem(title:"Done", style: .Plain, target: self, action: "setEndRepeat")
        self.navigationItem.rightBarButtonItem = self.doneButton

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePickerChanged(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        endRepeat = dateFormatter.stringFromDate(datePicker.date)

    }
    
    
    func setEndRepeat() {
        self.performSegueWithIdentifier("unwindFromEndRepeatTableViewController", sender: self)
    }
    
    func togglePicker(picker: String) {
        if picker == "onDate" {
            pickerHidden = !pickerHidden
        } else {
            pickerHidden = true
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            togglePicker("onDate")
            datePickerChanged(self)
            onDateCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            neverCell.accessoryType = UITableViewCellAccessoryType.None
        } else {
            togglePicker("close")
            endRepeat = "Never"
            neverCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            onDateCell.accessoryType = UITableViewCellAccessoryType.None
        }
    }

    var pickerHidden = true
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if pickerHidden && indexPath.row == 2 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
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
