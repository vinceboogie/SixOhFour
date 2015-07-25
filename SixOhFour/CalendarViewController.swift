//
//  CalendarViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/26/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CVCalendarViewDelegate {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    var shouldShowDaysOut = true
    var animationFinished = true
    var today: String!
    
    // Dummy schedule for development
    var schedule: [Schedule]!
    var mySchedule: [String: [Schedule]]!
    
    var currentMonth = CVDate(date: NSDate()).displayMonth()
    let weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.monthLabel.text = CVDate(date: NSDate()).displayMonthYear()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        schedule = [Schedule]()
        mySchedule = [String: [Schedule]]()
       
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        today = dateFormatter.stringFromDate(NSDate())
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IB Actions
    
    @IBAction func backToCalendar(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindAfterSaveSchedule(segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! AddScheduleTableViewController
        
        if((sourceVC.schedule) != nil) {
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            
            var key = dateFormatter.stringFromDate(sourceVC.startShift)
            
            if mySchedule[key] != nil {
                schedule = mySchedule[key]
            } else {
                schedule = []
            }
            
            schedule.append(sourceVC.schedule)
            
            mySchedule[key] = self.schedule
            tableView.reloadData()
        }
        
        var arr = mySchedule.keys.array
    }
    
    
    // MARK: Table View Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mySchedule[today] != nil {
            var todaySchedule = mySchedule[today]!

            return todaySchedule.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var todaySchedule = [Schedule]()
        
        if mySchedule[today] != nil {
            todaySchedule = mySchedule[today]!
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TodayScheduleCell", forIndexPath: indexPath) as! TodayScheduleCell
        
        cell.shift = todaySchedule[indexPath.row]
        
        return cell
    }
    
    
    
    // MARK: Calendar View Delegate
    
    func shouldShowWeekdaysOut() -> Bool {
        return self.shouldShowDaysOut
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        if let currentDay =  dayView.date?.day {
            if let index = dayView.weekdayIndex {
                self.todayLabel.text = weekday[index-1] + ", \(currentMonth) \(currentDay)"
                
                if let currentYear = dayView.date?.year {
                    today = "\(currentMonth) \(currentDay), \(currentYear)"
                }
                
                tableView.reloadData()
            }
        }
    }

    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> UIColor {
        if dayView.date?.day == 3 {
            return .redColor()
        } else if dayView.date?.day == 5 {
            return .blackColor()
        } else if dayView.date?.day == 2 {
            return .blueColor()
        }
        
        return .greenColor()
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        
        if dayView.date?.day == 3 || dayView.date?.day == 5 || dayView.date?.day == 2 {
            return true
        } else {
            return false
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    
    func presentedDateUpdated(date: CVDate) {
        if self.monthLabel.text != date.displayMonthYear() && self.animationFinished {
            
            currentMonth = date.displayMonth()
            
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.displayMonthYear()
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { (finished) -> Void in
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        let calendarManager = CVCalendarManager.sharedManager
        let components = calendarManager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleMonthViewWithDate(resultDate)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addScheduleSegue" {
            let destinationVC = segue.destinationViewController as! UITableViewController
            destinationVC.navigationItem.title = "Add Schedule"
            destinationVC.hidesBottomBarWhenPushed = true;
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target: nil, action: nil)
        }
    }
    

}
