//
//  ClockInViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/26/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class ClockInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var timer = NSTimer()
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    var hours: Int = 0
    
    @IBOutlet weak var dateTimestampDisplay: UILabel!
    var stopWatchString: String = ""
    
    var laps: [String] = []
    var timeDescription: String = ""
    var lapsDict: NSDictionary = ["":""]
    
    var rowNumber: Int = 0
    
    var startStopWatch: Bool = true
    var addLap: Bool = false
    
    @IBOutlet weak var stopWatchLabel: UILabel!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var breakButton: UIButton! //lapreset
    
    @IBAction func startStop(sender: AnyObject) {
        
        //IF USER CLICKED 1st button
        if startStopWatch == true {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateStopWatch"), userInfo: nil, repeats: true)
            
            startStopWatch = false
            
            startStopButton.setTitle("Clock Out", forState: UIControlState.Normal)
            breakButton.setTitle("Timestamp", forState: UIControlState.Normal)
            
            breakButton.enabled = true
            
            addLap = true
            
            var timestamp1 = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .MediumStyle)
            
            laps.append(timestamp1)
            timeDescription = "Clock In"
            lapsTableView.reloadData()
            
            println(laps)
            
            
        } else {
            
            //IF USER CLICKED 1st button again
            timer.invalidate()
            startStopWatch = true
            
            startStopButton.setTitle("Continue Timer", forState: UIControlState.Normal)
            breakButton.setTitle("Reset", forState: UIControlState.Normal)
            
            addLap = false
            
        }
        
    }
    
    @IBAction func lapReset(sender: AnyObject) {
        
        //IF USER CLICKED 2nd BUTTON
        if addLap == true {
            var timestamp2 = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .MediumStyle)
            
            laps.append(timestamp2)
            //lapsDict.append(timeDescription:timestamp2)
            timeDescription = "Started Lunch"
            lapsTableView.reloadData()
            
        } else {
            
            //IF USER CLICKED 2nd BUTTON again
            addLap = false
            
            startStopButton.setTitle("New Shift", forState: UIControlState.Normal)
            breakButton.setTitle(" ", forState: UIControlState.Normal)
            breakButton.enabled = false
            
            //clears all the laps when clicked reset
            laps.removeAll(keepCapacity: false)
            lapsTableView.reloadData()
            
            fractions = 0
            minutes = 0
            seconds = 0
            hours = 0
            
            stopWatchString = "00:00:00"
            stopWatchLabel.text = stopWatchString
            
            
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopWatchLabel.text = "00:00:00"
        breakButton.enabled = false
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateStopWatch() {
        
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
        
        cell.textLabel!.text = timeDescription
        //cell.textLabel!.text = "Timestamp #\(indexPath.row + 1)"
        
        cell.detailTextLabel?.text = laps[indexPath.row]
        
        rowNumber = indexPath.row + 1
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    
}

