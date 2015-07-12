
//  ClockInViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/26/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class ClockInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    //, writeValueBackDelegate2 {

    var timer = NSTimer()
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    var hours: Int = 0

    var breakTimer = NSTimer()
    var breakMinutes: Int = 0
    var breakSeconds: Int = 0
    var breakFractions: Int = 0
    var breakHours: Int = 0
    
    @IBOutlet weak var workTitleLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var breakTitleLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!

    var stopWatchString: String = ""
    var breakWatchString: String = ""
    
    var timelogTimestamp: [String] = []
    var timelogDescription: [String] = []
    
//    var startStopWatch: Bool = true
//    var startBreakWatch: Bool = true
//    
//    var addLap: Bool = false
//    var startBreak: Int = 0
    var timelogFlow: Int = 0
    
    @IBOutlet weak var jobColorDisplay: JobColorView!
    @IBOutlet weak var jobTitleDisplayButton: UIButton!
    @IBOutlet weak var jobTitleDisplayLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var breakButton: UIButton! //lapreset
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        jobTitleDisplayLabel.text = "Select Job"
        workTitleLabel.text = " "
        workTimeLabel.text = "00:00:00"
        breakButton.enabled = false
        breakTitleLabel.text = " "
        breakTimeLabel.text = " "
        }
    
//MARK: IBActions:
//2 buttons control clockin,clockout,start break, end break, reset

    @IBAction func startStop(sender: AnyObject) {
        
        //CLOCK IN
//        if startStopWatch == true {
        if timelogFlow == 0 {
            workTitleLabel.text = "Time you've worked"
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runWorkTimer"), userInfo: nil, repeats: true)
            
//            startStopWatch = false
            
            startStopButton.setTitle("Clock Out", forState: UIControlState.Normal)
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            
            breakButton.enabled = true
//            addLap = true
            
            timelogDescription.append("Clocked In")
            appendToTimeTableView()
            saveToCoreDate()
  
            timelogFlow = 1
            println(timelogFlow)
        } else {
        //CLOCK OUT
            
            workTitleLabel.text = "Total time you worked for the shift"
            timelogDescription.append("Clocked Out")
            appendToTimeTableView()
            saveToCoreDate()
            
            timer.invalidate()
//            startStopWatch = true
            
            startStopButton.setTitle("Done with Shift", forState: UIControlState.Normal)
            startStopButton.enabled = false
            breakButton.setTitle("Reset", forState: UIControlState.Normal)
            
//            addLap = false
            
            timelogFlow = 2
            println(timelogFlow)

        }
        
    }
    
    @IBAction func lapReset(sender: AnyObject) {
        
        //STARTED BREAK
//        if addLap == true && startBreak == 0 {
        if timelogFlow == 1 {
            
            breakMinutes = 0
            breakSeconds = 0
            breakFractions = 0
            breakHours = 0

            breakTitleLabel.textColor = UIColor.blueColor()
            breakTimeLabel.textColor = UIColor.blueColor()
            
            timer.invalidate()
            
            breakTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runBreakTimer"), userInfo: nil, repeats: true)

            breakTimeLabel.text = breakWatchString
            
            startStopButton.enabled = false
            breakButton.setTitle("End Break", forState: UIControlState.Normal)
            
            timelogDescription.append("Started Break")
            appendToTimeTableView()
            saveToCoreDate()
            
            breakTitleLabel.text = "Time you've been on break"

            
//            addLap = true
//            startBreak = 1

            timelogFlow = 3
            println(timelogFlow)

            
        //ENDED BREAK
//        } else if addLap == true && startBreak == 1 {
        } else if timelogFlow == 3 {
            workTitleLabel.text = "Total time you've worked"
            breakTimeLabel.text = breakWatchString
            
            breakTitleLabel.textColor = UIColor.grayColor()
            breakTimeLabel.textColor = UIColor.grayColor()
            breakTitleLabel.text = "Duration of your last break"
            

            breakTimer.invalidate()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runWorkTimer"), userInfo: nil, repeats: true)

            
            startStopButton.enabled = true
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            timelogDescription.append("Ended Break")
            
            appendToTimeTableView()
            saveToCoreDate()
            
//            addLap = true
//            startBreak = 0
            
            timelogFlow = 1
            println(timelogFlow)

        //RESET
        } else {
            
            startStopButton.setTitle("Clock In", forState: UIControlState.Normal)
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            breakButton.enabled = false
            
            //clears all the laps when clicked reset
            timelogTimestamp.removeAll(keepCapacity: false)
            lapsTableView.reloadData()
            
            fractions = 0
            minutes = 0
            seconds = 0
            hours = 0

            workTitleLabel.text = " "
            workTimeLabel.text = "00:00:00"
            breakTimeLabel.text = " "
            breakTitleLabel.text = " "

            
            startStopButton.enabled = true

            
//            addLap = false
//            startBreak = 0
//            startStopWatch = true

            timelogTimestamp = []
            timelogDescription = []
            
            timelogFlow = 0
        }
        
        
    }
    
//MARK: functions
    
    func saveToCoreDate(){
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newTimeLogs = NSEntityDescription.insertNewObjectForEntityForName("TimeLogs", inManagedObjectContext: context) as! NSManagedObject
        
        newTimeLogs.setValue("" + timelogDescription.last!, forKey: "timelogTitle")
        newTimeLogs.setValue("" + timelogTimestamp.last!, forKey: "timelogTimestamp")
        
        context.save(nil)
        
        println(newTimeLogs)
    }
    
    func appendToTimeTableView() {
        var timeStampAll = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .MediumStyle)
        timelogTimestamp.append(timeStampAll)
        lapsTableView.reloadData()
    }

    
    func runBreakTimer() {
        
        breakSeconds += 1
        
        if breakSeconds == 60 {
            breakMinutes += 1
            breakSeconds = 0
        }
        if breakMinutes == 60 {
            breakHours += 1
            breakMinutes = 0
        }
        let fractionsStringBreak = breakFractions > 9 ? "\(breakFractions)" : "0\(breakFractions)"
        let secondsStringBreak = breakSeconds > 9 ? "\(breakSeconds)" : "0\(breakSeconds)"
        let minutesStringBreak = breakMinutes > 9 ? "\(breakMinutes)" : "0\(breakMinutes)"
        let hoursStringBreak = breakHours > 9 ? "\(breakHours)" : "0\(breakHours)"
        
        breakWatchString  = "\(hoursStringBreak):\(minutesStringBreak):\(secondsStringBreak)"
        breakTimeLabel.text = breakWatchString
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
        
        let fractionsString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        
        stopWatchString  = "\(hoursString):\(minutesString):\(secondsString)"
        workTimeLabel.text = stopWatchString
        
    }
    
    //Getting data from Popover - When selecting Job
    @IBAction func unwindFromClockInPopoverViewControllerAction (segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! ClockInJobsPopoverViewController
        
        if((sourceVC.selectedJob) != nil ) {
            
            jobTitleDisplayLabel.text = sourceVC.selectedJob.jobName
            jobColorDisplay.color = sourceVC.selectedJob.getJobColor()
        }
    }

    
//Table View funct
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        cell.backgroundColor = self.view.backgroundColor
        
        cell.textLabel!.text = timelogDescription[indexPath.row]
        //cell.textLabel!.text = "Timestamp #\(indexPath.row + 1)"
        
        cell.detailTextLabel?.text = timelogTimestamp[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelogTimestamp.count
    }
    

//Popover Effect - Drop down menu --->>>>>
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let popupView = segue.destinationViewController as? UIViewController
        {
            if let popup = popupView.popoverPresentationController
            {
                popup.delegate = self
            }
        }
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    func writeValueBack2(vc: ClockInJobsPopoverViewController, value: String) {
        self.jobTitleDisplayLabel.text = "$\(value)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } //Popover Effect Ended <<<<<-------

}

