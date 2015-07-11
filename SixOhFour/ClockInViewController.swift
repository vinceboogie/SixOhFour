
//  ClockInViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/26/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class ClockInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, writeValueBackDelegate2 {

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
    
    @IBOutlet weak var durationDescriptionLabel: UILabel!

    var stopWatchString: String = ""
    var breakWatchString: String = ""
    
    var timelogTimestamp: [String] = []
    var timelogDescription: [String] = []
    
    var lapsDict: NSDictionary = ["":""]
    
    var rowNumber: Int = 0
    
    var startStopWatch: Bool = true
    var startBreakWatch: Bool = true
    
    var addLap: Bool = false
    var startBreak: Int = 0
    var timerFlow: Int = 0
    
    
    @IBOutlet weak var jobColorDisplay: JobColorView!
    @IBOutlet weak var jobTitleDisplayButton: UIButton!
    @IBOutlet weak var jobTitleDisplayLabel: UILabel!
    
    
    
    @IBOutlet weak var stopWatchLabel: UILabel!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var breakButton: UIButton! //lapreset
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopWatchLabel.text = "00:00:00"
        breakButton.enabled = false
        durationDescriptionLabel.text = " "
        jobTitleDisplayLabel.text = "Select Job"
        
    }
    
    
    
    @IBAction func startStop(sender: AnyObject) {
        
        //CLOCK IN (User clicked 1st button)
        if startStopWatch == true {
            durationDescriptionLabel.text = "Time you've worked"
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runWorkTimer"), userInfo: nil, repeats: true)
            
            startStopWatch = false
            
            startStopButton.setTitle("Clock Out", forState: UIControlState.Normal)
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            
            breakButton.enabled = true
            addLap = true
            
            timelogDescription.append("Clock In")
            appendToTimeTableView()
            saveToCoreDate()
            
        } else {
            
            //CLOCK OUT (User clicked 1st button again
            timelogDescription.append("Clock Out")
            appendToTimeTableView()
            saveToCoreDate()
            
            timer.invalidate()
            startStopWatch = true
            
            startStopButton.setTitle("Continue Timer", forState: UIControlState.Normal)
            breakButton.setTitle("Reset", forState: UIControlState.Normal)
            
            addLap = false
            
            
        }
        
    }
    
    @IBAction func lapReset(sender: AnyObject) {
        
        //IF USER CLICKED 2nd BUTTON
        if addLap == true && startBreak == 0 {
            durationDescriptionLabel.text = "Time you've been on break"
            breakButton.setTitle("End Break", forState: UIControlState.Normal)
            timelogDescription.append("Started Break")
            appendToTimeTableView()
            saveToCoreDate()
            
            addLap = true
            startBreak = 1
            
        //IF USER CLICKED 2nd button a 2nd time
        } else if addLap == true && startBreak == 1 {

            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            timelogDescription.append("Ended Break")
            appendToTimeTableView()
            saveToCoreDate()
            
            addLap = true
            startBreak = 0
            
        //IF USER CLICKED 2nd button Twice
        } else {
            
            startStopButton.setTitle("New Shift", forState: UIControlState.Normal)
            breakButton.setTitle(" ", forState: UIControlState.Normal)
            breakButton.enabled = false
            
            //clears all the laps when clicked reset
            timelogTimestamp.removeAll(keepCapacity: false)
            lapsTableView.reloadData()
            
            fractions = 0
            minutes = 0
            seconds = 0
            hours = 0
            stopWatchString = "00:00:00"
            stopWatchLabel.text = stopWatchString
         
            addLap = false
            startBreak = 0
            startStopWatch = true
        }
        
        
    }
    
    //MARK: IB Actions
    
    @IBAction func unwindFromClockInPopoverViewControllerAction (segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! ClockInJobsPopoverViewController

        if((sourceVC.selectedJob) != nil ) {
            
            jobTitleDisplayLabel.text = sourceVC.selectedJob.jobName
            jobColorDisplay.color = sourceVC.selectedJob.getJobColor()
        }
     
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func runWorkTimer() {
        
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
        
        stopWatchString  = "\(hoursStringBreak):\(minutesStringBreak):\(secondsStringBreak)"
        stopWatchLabel.text = stopWatchString
        
    }
    
    func runBreakTimer() {
        
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
        stopWatchLabel.text = stopWatchString
        
    }
    
    //Table View Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        cell.backgroundColor = self.view.backgroundColor
        
        cell.textLabel!.text = timelogDescription[indexPath.row]
        //cell.textLabel!.text = "Timestamp #\(indexPath.row + 1)"
        
        cell.detailTextLabel?.text = timelogTimestamp[indexPath.row]
        
        rowNumber = indexPath.row + 1
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelogTimestamp.count
    }
    
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

}

