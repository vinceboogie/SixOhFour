
//  ClockInViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/26/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class ClockInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, NSFetchedResultsControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    //, writeValueBackDelegate2 {
    
    @IBOutlet weak var workTitleLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var breakTitleLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var editBreakInstruction: UILabel!
    
    @IBOutlet weak var jobColorDisplay: JobColorView!
    @IBOutlet weak var jobTitleDisplayButton: UIButton!
    @IBOutlet weak var jobTitleDisplayLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var editBreakButton: UIButton!
    
    var timer = NSTimer()
    var minutes: Int = 0
    var seconds: Int = 0
    var hours: Int = 0
    
    var breakTimer = NSTimer()
    var breakMinutes: Int = 0
    var breakSeconds: Int = 0
    var breakHours: Int = 0
    
    var breakTimerOver = NSTimer()
    
    var stopWatchString: String = ""
    var breakWatchString: String = ""
    
    var timelogTimestamp: [String] = []
    var timelogDescription: [String] = []
    
    var timelogFlow: Int = 0
    var breakCount: Int = 0
    
    var jobListEmpty = true
    var selectedJob = "Select A Job"
    
    var frc : NSFetchedResultsController = NSFetchedResultsController()
    
    let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        frc = NSFetchedResultsController(fetchRequest: TimeLogsFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.lapsTableView.rowHeight = 30.0
        workTitleLabel.text = " "
        workTimeLabel.text = "00:00:00"
        breakButton.enabled = false
        breakTitleLabel.text = " "
        breakTimeLabel.text = " "
        editBreakInstruction.hidden = true
        editBreakButton.enabled = false
        
        frc = getFetchedResultsController()
        frc.delegate = self
        frc.performFetch(nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if jobListEmpty {
            startStopButton.enabled = false
            workTimeLabel.textColor = UIColor.grayColor()
        }
        
        
        if selectedJob == "Select A Job" {
            // Fetch jobs list to keep refreshing changes
            var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            var context:NSManagedObjectContext = appDel.managedObjectContext!
            
            var request = NSFetchRequest(entityName: "Jobs")
            request.returnsObjectsAsFaults = false ;
            
            var results:NSArray = context.executeFetchRequest(request, error: nil)!
            
            if results.count > 0 {
                //Fetches the first jobs
//                var firstJob = results[0] as! Jobs
                jobTitleDisplayLabel.text = selectedJob//.jobName
//                jobColorDisplay.color = firstJob.getJobColor()
                jobTitleDisplayLabel.textColor = UIColor.blackColor()
                
                jobListEmpty = false
                startStopButton.enabled = true
                jobTitleDisplayLabel.textColor = UIColor.blackColor()
                
            } else {
                jobTitleDisplayLabel.text = "Add a Job"
                jobTitleDisplayLabel.textColor = UIColor.blueColor()
                jobColorDisplay.color = UIColor.lightGrayColor()
            }
            
        } else {
            var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            var context:NSManagedObjectContext = appDel.managedObjectContext!
            
            var request = NSFetchRequest(entityName: "Jobs")
            request.returnsObjectsAsFaults = false ;
            
            var results:NSArray = context.executeFetchRequest(request, error: nil)!

            jobTitleDisplayLabel.text = selectedJob
            //selectedJob = ""
        }

    
    }
    
//MARK: IBActions:
//2 buttons control clockin,clockout,start break, end break, reset

    @IBAction func startStop(sender: AnyObject) {
        
        //CLOCK IN
        
        //Trying to give a warning to the user to select a job
        if selectedJob.isEmpty == true {
            let alertJobSelect = UIAlertController(title: "WARNING!",
                message: "Please select a job:",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertJobSelect.addAction(UIAlertAction(title: "Job#1", style: .Default, handler: nil))
            
            presentViewController(alertJobSelect, animated: true, completion:nil)
        } else {
            println(selectedJob)
        }
        
        //Begin Shift
        if timelogFlow == 0 {
            workTitleLabel.text = "Time you've worked"
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runWorkTimer"), userInfo: nil, repeats: true)
            
            startStopButton.setTitle("Clock Out", forState: UIControlState.Normal)
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            
            breakButton.enabled = true
            
            timelogDescription.append("Clocked In")
            appendToTimeTableView()
            saveToCoreDate()
  
            timelogFlow = 1
        } else {
            
        //CLOCK OUT
            workTitleLabel.text = "Total time you've worked"
            timelogDescription.append("Clocked Out")
            appendToTimeTableView()
            saveToCoreDate()
            
            timer.invalidate()
            
            startStopButton.setTitle("Done with Shift", forState: UIControlState.Normal)
            startStopButton.enabled = false
            breakButton.setTitle("Reset", forState: UIControlState.Normal)
            
            timelogFlow = 2

        }
        
    }
    
    

    
    @IBAction func lapReset(sender: AnyObject) {
    
        //STARTED BREAK
        if timelogFlow == 1 {
            
            breakTimeLabel.hidden = false
            breakTitleLabel.hidden = false
            editBreakInstruction.hidden = false
            editBreakButton.enabled = true

            breakMinutes = 5
            breakSeconds = 0
            breakHours = 0

            //Display Break time instantly
            let secondsStringBreak = breakSeconds > 9 ? "\(breakSeconds)" : "0\(breakSeconds)"
            let minutesStringBreak = breakMinutes > 9 ? "\(breakMinutes)" : "0\(breakMinutes)"
            let hoursStringBreak = breakHours > 9 ? "\(breakHours)" : "0\(breakHours)"
            breakWatchString  = "\(hoursStringBreak):\(minutesStringBreak):\(secondsStringBreak)"
            breakTimeLabel.text = breakWatchString
            
            breakCount++
            
            if breakHours > 0 {
                breakTitleLabel.text = "Your break is set to \(breakHours) hr and \(breakMinutes) min"
            } else if breakHours == 0 && breakMinutes > 0 {
                breakTitleLabel.text = "Your break is set to \(breakMinutes) min"
            } else if breakMinutes == 0 && breakSeconds > 0 {
                breakTitleLabel.text = "Your break is set to \(breakSeconds) sec"
            }

            
            breakTitleLabel.textColor = UIColor.blueColor()
            breakTimeLabel.textColor = UIColor.blueColor()
            editBreakInstruction.textColor = UIColor.blueColor()
            
            timer.invalidate()
            
            breakTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runBreakTimer"), userInfo: nil, repeats: true)
            
            startStopButton.enabled = false
            breakButton.setTitle("End Break", forState: UIControlState.Normal)
            
            if breakCount == 1 {
            timelogDescription.append("Started Break")
            } else {
            timelogDescription.append("Started Break #\(breakCount)")
            }
            
            appendToTimeTableView()
            saveToCoreDate()

            timelogFlow = 3

            
        //ENDED BREAK
        } else if timelogFlow == 3 {
            
            breakTimerOver.invalidate()
            
            breakTimeLabel.hidden = true
            breakTitleLabel.hidden = true
            editBreakInstruction.hidden = true
            editBreakButton.enabled = false

            breakMinutes = 0
            breakSeconds = 5
            breakHours = 0
            
            breakTimer.invalidate()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runWorkTimer"), userInfo: nil, repeats: true)

            
            startStopButton.enabled = true
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            
            if breakCount == 1 {
                timelogDescription.append("Ended Break")
            } else {
                timelogDescription.append("Ended Break #\(breakCount)")
            }
    
            appendToTimeTableView()
            saveToCoreDate()
            
            timelogFlow = 1
            
            breakTimeLabel.text = "0\(breakHours):\(breakMinutes):0\(breakSeconds)"
            
        //RESET
        } else {
            
            startStopButton.setTitle("Clock In", forState: UIControlState.Normal)
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            breakButton.enabled = false
            
            //clears all the laps when clicked reset
            timelogTimestamp.removeAll(keepCapacity: false)
            lapsTableView.reloadData()
            
            minutes = 0
            seconds = 0
            hours = 0
            
            breakCount = 0

            workTitleLabel.text = " "
            workTimeLabel.text = "00:00:00"
            breakTimeLabel.text = " "
            breakTitleLabel.text = " "

            startStopButton.enabled = true

            timelogTimestamp = []
            timelogDescription = []
            
            timelogFlow = 0
        }
        
        
    }
    
    @IBAction func selectJobButton(sender: AnyObject) {
        if jobListEmpty {
            let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
            let addJobsVC: AddJobTableViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("AddJobTableViewController") as! AddJobTableViewController
                    
            self.navigationController?.pushViewController(addJobsVC, animated: true)
            
        } else {
            self.performSegueWithIdentifier("displayJobList", sender: self)
        }
    }

    @IBAction func editBreakTime(sender: AnyObject) {
    //Edit break time
//        let passwordPrompt = UIAlertController(title: "Set Breatime", message: "Enter new breaktime duration:", preferredStyle: UIAlertControllerStyle.Alert)
//        passwordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
//        passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//        passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
//            textField.placeholder = "Minutes"
//            textField.secureTextEntry = false
//            textField.keyboardType = UIKeyboardType.NumberPad
//        })
// 
//        presentViewController(passwordPrompt, animated: true, completion: nil)
//        
//        //addAlert()
    }
    
//MARK: functions
    
    func allTimeLogsFetchRequest() -> NSFetchRequest {
        
        var fetchRequest = NSFetchRequest(entityName: "TimeLogs")
        //let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.predicate = nil
        //fetchRequest.sortDescriptors = [sortDescriptor]
        //fetchRequest.fetchBatchSize = 20
        
        return fetchRequest
    }
    
    func TimeLogsFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TimeLogs")
        let sortDescriptor = NSSortDescriptor(key: "timelogTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func saveToCoreDate(){
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newTimeLogs = NSEntityDescription.insertNewObjectForEntityForName("TimeLogs", inManagedObjectContext: context) as! NSManagedObject
        
        newTimeLogs.setValue("" + timelogDescription.last!, forKey: "timelogTitle")
        newTimeLogs.setValue("" + timelogTimestamp.last!, forKey: "timelogTimestamp")
        
        newTimeLogs.setValue("Test1", forKey: "timelogJob")
        newTimeLogs.setValue("Test2", forKey: "timelogDuration")
        newTimeLogs.setValue("Test3", forKey: "timelogComment")

        
        context.save(nil)
        
        println(newTimeLogs)
    }
    
    func appendToTimeTableView() {
        var timeStampAll = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .MediumStyle)
        timelogTimestamp.append(timeStampAll)
        lapsTableView.reloadData()
    }

    
    func runBreakTimer() {

        let secondsStringBreak = breakSeconds > 9 ? "\(breakSeconds)" : "0\(breakSeconds)"
        let minutesStringBreak = breakMinutes > 9 ? "\(breakMinutes)" : "0\(breakMinutes)"
        let hoursStringBreak = breakHours > 9 ? "\(breakHours)" : "0\(breakHours)"
    
        breakWatchString  = "\(hoursStringBreak):\(minutesStringBreak):\(secondsStringBreak)"
        breakTimeLabel.text = breakWatchString

        if breakSeconds > 0 {
            breakSeconds--
        } else if breakSeconds == 0 && breakMinutes > 0 {
            breakMinutes--
            breakSeconds = 59
        } else if breakMinutes == 0 && breakHours > 0 {
            breakHours--
            breakMinutes = 59
        } else {
            
            //Notifications outside the App (Home screen and Lock Screen)
            var localNotification: UILocalNotification = UILocalNotification()
            localNotification.alertAction = "PUCHIE"
            localNotification.alertBody = "Your breaktime is over!"
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 0) //seconds from now
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            //Notifications insdie the App (Home screen and Lock Screen)
            let alert = UIAlertController(title: "Breaktime is over!",
                message: "Please choose from the following:",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "View", style: .Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Clock In", style: .Default, handler: {
                action in self.lapReset(true)
            }))
            alert.addAction(UIAlertAction(title: "Add 5 Minutes", style: .Default, handler: {
                action in self.breakTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runBreakTimer"), userInfo: nil, repeats: true)
                self.breakMinutes = 5
                self.breakTitleLabel.text = "You've extended your break by 5 minutes"
            }))
            
            presentViewController(alert, animated: true, completion:nil)
            
            breakTimer.invalidate()
            
            breakTimerOver = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runBreakTimerOver"), userInfo: nil, repeats: true)
            
        }
    }
    
    //redundant code - need to combine both timers
    func runWorkTimer() {
        
        seconds += 1
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        
        stopWatchString  = "\(hoursString):\(minutesString):\(secondsString)"
        workTimeLabel.text = stopWatchString
        
    }

    //redundant code - need to combine both timers
    func runBreakTimerOver() {
        
        //Show time over break
        breakTitleLabel.textColor = UIColor.redColor()
        breakTitleLabel.text = "You are running over your breaktime"
        breakTimeLabel.textColor = UIColor.redColor()
        
        
        breakSeconds += 1
        
        if breakSeconds == 60 {
            breakMinutes += 1
            breakSeconds = 0
        }
        
        if breakMinutes == 60 {
            breakHours += 1
            breakMinutes = 0
        }
        
        let breakSecondsString = breakSeconds > 9 ? "\(breakSeconds)" : "0\(breakSeconds)"
        let breakMinutesString = breakMinutes > 9 ? "\(breakMinutes)" : "0\(breakMinutes)"
        let breakHoursString = breakHours > 9 ? "\(breakHours)" : "0\(breakHours)"
        
        breakWatchString  = "\(breakHoursString):\(breakMinutesString):\(breakSecondsString)"
        breakTimeLabel.text = breakWatchString

    }
    
    //Getting data from Popover - When selecting Job
    @IBAction func unwindFromClockInPopoverViewControllerAction (segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! ClockInJobsPopoverViewController
        
        if((sourceVC.selectedJob) != nil ) {
            selectedJob = sourceVC.selectedJob.jobName
            
//            jobTitleDisplayLabel.text = sourceVC.selectedJob.jobName
            jobColorDisplay.color = sourceVC.selectedJob.getJobColor()
        }
    }

    
//Table View funct
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        cell.backgroundColor = self.view.backgroundColor
        
        cell.textLabel!.font = UIFont.systemFontOfSize(12.0)
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12.0)

//        cell.textLabel!.text = timelogDescription[indexPath.row] //ascending order
//        cell.detailTextLabel?.text = timelogTimestamp[indexPath.row] //ascending order
        
        cell.textLabel!.text = timelogDescription[timelogTimestamp.count - indexPath.row - 1] //descending order
        cell.detailTextLabel?.text = timelogTimestamp[timelogTimestamp.count - indexPath.row - 1] //descending order

        //changing to custom cell =
        return cell
//        //changing to custom cell =
//        
//        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
//        var context:NSManagedObjectContext = appDel.managedObjectContext!
//        var newTimeLogs = NSEntityDescription.insertNewObjectForEntityForName("TimeLogs", inManagedObjectContext: context) as! NSManagedObject
//        var request = NSFetchRequest(entityName: "TimeLogs")
//        request.returnsObjectsAsFaults = false ;
////        
//        var arrayOfTimeLogs = [TimeLogs]()
////        
//        var results:NSArray = context.executeFetchRequest(request, error: nil)!
////
//        arrayOfTimeLogs = results as! [TimeLogs]
//
//        let cell2 = tableView.dequeueReusableCellWithIdentifier("ClockInJobsCell", forIndexPath: indexPath) as! ClockIn_TimeLogCell
//        

////        cell2.timelogTitleLabel = arrayOfTimeLogs[indexPath.row]
//
//        return cell2

//        let cell3: TimeLogs = tableView.dequeueReusableCellWithIdentifier("ClockInTimeLogCell")
//        
//        cell3.timelogTimestamp = arrayOfTimeLogs.timelogTimestamp[indexPath.row]
//        
//        return cell3
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelogTimestamp.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetails", sender: tableView.cellForRowAtIndexPath(indexPath))
        
        //Send Core Data Timelog Details
        
//            let nItem : TimeLogs = frc.objectAtIndexPath(indexPath) as! TimeLogs
        
        
    }


//Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
//        //Popover Effect - Drop down menu --->>>>>
//
//        if let popupView = segue.destinationViewController as? UIViewController {
//            if let popup = popupView.popoverPresentationController
//            {
//                popup.delegate = self
//            }
//        } //Popover Effect Ended <<<<<-------

        //New Jobs List without the Popover
        if segue.identifier == "displayJobsList" {
            let destinationVC = segue.destinationViewController as! UIViewController
            destinationVC.navigationItem.title = ""
            destinationVC.hidesBottomBarWhenPushed = true;
            //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target: nil, action: nil)
        }
        
        if segue.identifier == "editBreaktimeSegue" {
            let destinationVC = segue.destinationViewController as! UIViewController
            destinationVC.navigationItem.title = "Set Breaktime"
            destinationVC.hidesBottomBarWhenPushed = true;
        }
        
        //Send Core Data Timelog Details
        
        if segue.identifier == "showDetails" {
            let cell = sender as! UITableViewCell
            let indexPath = lapsTableView.indexPathForCell(cell)
            let itemController : detailsTimelogViewController = segue.destinationViewController as! detailsTimelogViewController
            
//            let nItem : TimeLogs = frc.objectAtIndexPath(indexPath!) as! TimeLogs
            
//            let nItem = NSEntityDescription.insertNewObjectForEntityForName("TimeLogs", inManagedObjectContext: context) as! TimeLogs
//            
//            nItem.setValue("Test1", forKey: "timelogJob")
//            nItem.setValue("Test2", forKey: "timelogDuration")
//            nItem.setValue("Test3", forKey: "timelogComment")
//            nItem.setValue("Test4", forKey: "timelogTimestamp")
//            nItem.setValue("Test5", forKey: "timelogTitle")
//            
//            itemController.nItem = nItem
            
        }

    }
    
    // MARK: - BreakTime Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breakMinutes
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(row)"
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            breakMinutes = 0
        } else {
            breakMinutes = row
        }
    }
    
//    //Popover Effect - Drop down menu --->>>>>
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
//    {
//        return UIModalPresentationStyle.None
//    }//Popover Effect Ended <<<<<-------
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

