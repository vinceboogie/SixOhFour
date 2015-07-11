//
//  AddScheduleTableViewController.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/8/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class AddScheduleTableViewController: UITableViewController {

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var jobColorView: JobColorView!

    var saveButton: UIBarButtonItem!
    var jobListEmpty = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // TODO - Change Say Hello to Save Function
        saveButton = UIBarButtonItem(title:"Save", style: .Plain, target: self, action: "sayHello")
        self.navigationItem.rightBarButtonItem = saveButton
        
        datePickerChanged(startLabel, datePicker: startDatePicker)
        saveButton.enabled = false
        
        
        // Fetch first Job
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Jobs")
        request.returnsObjectsAsFaults = false ;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            var firstJob = results[0] as! Jobs
            jobNameLabel.text = firstJob.jobName
            jobColorView.color = firstJob.getJobColor()
            jobListEmpty = false
        } else {
            jobNameLabel.text = "Add a Job"
            jobNameLabel.textColor = UIColor.lightGrayColor()
            jobColorView.color = UIColor.lightGrayColor()
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Testing Stuff
    
    func sayHello() {
        println("Hello!")
    }
    
    
    // MARK: IB Actions
    
    @IBAction func startDatePickerValue(sender: AnyObject) {
        datePickerChanged(startLabel, datePicker: startDatePicker)
    }
    
    @IBAction func endDatePickerValue(sender: AnyObject) {
        datePickerChanged(endLabel, datePicker: endDatePicker)
    }
    
    @IBAction func unwindFromJobsListTableViewController (segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! JobsListTableViewController
        
        if((sourceVC.selectedJob) != nil) {
    
            jobNameLabel.text = sourceVC.selectedJob.jobName
            jobColorView.color = sourceVC.selectedJob.getJobColor()
        }
    }
    
    
    // MARK: Datepicker
    
    func datePickerChanged(label: UILabel, datePicker: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        
        label.text = dateFormatter.stringFromDate(datePicker.date)
        
        if datePicker == startDatePicker {
            if datePicker.date.compare(endDatePicker.date) == NSComparisonResult.OrderedDescending {
                endLabel.text = label.text
                endDatePicker.date = datePicker.date
            } else {
                endLabel.text = dateFormatter.stringFromDate(endDatePicker.date)
            }
        }
        
        if datePicker == endDatePicker {
            if datePicker.date.compare(startDatePicker.date) == NSComparisonResult.OrderedAscending {
                startLabel.text = label.text
                startDatePicker.date = datePicker.date
            }
        }
        
        toggleSaveButton()
    }
    
    private var startDatePickerHidden = true
    private var endDatePickerHidden = true
    
    func toggleDatePicker(datePicker: String) {
        
        if datePicker == "Start" {
            startDatePickerHidden = !startDatePickerHidden
            toggleLabelColor(startDatePickerHidden, label: startLabel)
            endDatePickerHidden = true
            toggleLabelColor(endDatePickerHidden, label: endLabel)
        } else if datePicker == "End" {
            endDatePickerHidden = !endDatePickerHidden
            toggleLabelColor(endDatePickerHidden, label: endLabel)
            startDatePickerHidden = true
            toggleLabelColor(startDatePickerHidden, label: startLabel)
        } else {
            // Close datepickers
            startDatePickerHidden = true
            endDatePickerHidden = true
            toggleLabelColor(startDatePickerHidden, label: startLabel)
            toggleLabelColor(endDatePickerHidden, label: endLabel)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleLabelColor(hidden: Bool, label: UILabel) {
        if hidden{
            label.textColor = UIColor.blackColor()
        } else {
            label.textColor = UIColor.redColor()
        }
    }
    
    func toggleSaveButton() {
        if jobListEmpty {
            saveButton.enabled = false
        } else if startDatePicker.date.compare(endDatePicker.date) == NSComparisonResult.OrderedAscending {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
        
        
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("CurrentJobCell", forIndexPath: indexPath) as! JobsListCell
//
//        if cell 
//        
//        return cell
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        if jobListEmpty && indexPath.section == 0 && indexPath.row == 0 {
//            let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
//            let addJobsVC: HomeViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
//            
////            self.navigationController?.dismissViewControllerAnimated(true, completion: {})
//            self.navigationController?.popToRootViewControllerAnimated(true)
//        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            toggleDatePicker("Start")
        } else if indexPath.section == 1 && indexPath.row == 2 {
            toggleDatePicker("End")
        } else {
            toggleDatePicker("Close")
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
   
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if startDatePickerHidden && indexPath.section == 1 && indexPath.row == 1 {
            return 0
        } else if endDatePickerHidden && indexPath.section == 1 && indexPath.row == 3 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "selectJob" {
            let destinationVC = segue.destinationViewController as! JobsListTableViewController
            destinationVC.currentSelection = jobNameLabel.text
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "selectJob" {
            if jobListEmpty {
                let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
                let addJobsVC: AddJobTableViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("AddJobTableViewController") as! AddJobTableViewController
                
                self.navigationController?.pushViewController(addJobsVC, animated: true)
                
            
                return false
                
            } else {
                return true
            }
        }
        
        return true
        
    }
    

}
