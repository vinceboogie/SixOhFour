//
//  CalendarViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/26/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedDate: NSDate!
    var monthSchedule: [ScheduledShift]!
    var daySchedule: [ScheduledShift]!
    var shift: ScheduledShift!
    
    var shouldShowDaysOut = true
    var animationFinished = true
    var currentMonth = CVDate(date: NSDate()).currentMonth
    
    let weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let dataManager = DataManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        
        tableView.delegate = self
        tableView.dataSource = self
        
        selectedDate = CVDate(date: NSDate()).convertedDate()
        daySchedule = [ScheduledShift]()
        
        // DELETE: Testing pre-populating colors
        var colors = dataManager.fetch("Color") as! [Color]
        println(colors)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let predicate = NSPredicate(format: "startDate contains[c] %@", currentMonth)
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: true)
        let sortDescriptors = [sortDescriptor]

        monthSchedule = dataManager.fetch("ScheduledShift", predicate: predicate, sortDescriptors: sortDescriptors) as! [ScheduledShift]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func backToCalendar(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindAfterSaveSchedule(segue: UIStoryboardSegue) {

    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addScheduleSegue" {
            let destinationVC = segue.destinationViewController as! AddScheduleTableViewController
            destinationVC.navigationItem.title = "Add Schedule"
            destinationVC.hidesBottomBarWhenPushed = true;
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target: nil, action: nil)
            
            let today = NSDate()
            
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
           
            let dateComponents = calendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay, fromDate: selectedDate)
            let timeComponents = calendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute, fromDate: today)
           
            dateComponents.setValue(timeComponents.hour, forComponent: NSCalendarUnit.CalendarUnitHour)
            dateComponents.setValue(timeComponents.minute, forComponent: NSCalendarUnit.CalendarUnitMinute)
            
            selectedDate = calendar.dateFromComponents(dateComponents)
            
            // Set start and end date to date selected on calendar
            destinationVC.startTime = self.selectedDate
            destinationVC.endTime = self.selectedDate
            
            destinationVC.isNewSchedule = true
        }
        
        if segue.identifier == "editSchedule" {
            let destinationVC = segue.destinationViewController as! AddScheduleTableViewController
            destinationVC.navigationItem.title = "Edit Schedule"
            destinationVC.hidesBottomBarWhenPushed = true;
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target: nil, action: nil)
            
            destinationVC.shift = self.shift
            
            destinationVC.isNewSchedule = false
        }
    }
}


// MARK: Table View Datasource

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if daySchedule != nil {
            return daySchedule.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodayScheduleCell", forIndexPath: indexPath) as! TodayScheduleCell
        
        cell.shift = daySchedule[indexPath.row]
        
        cell.jobColorView.setNeedsDisplay()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        shift = daySchedule[indexPath.row]
        
        self.performSegueWithIdentifier("editSchedule", sender: self)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            tableView.beginUpdates()
            let shiftToDelete = daySchedule[indexPath.row]
            daySchedule.removeAtIndex(indexPath.row)
            
            dataManager.delete(shiftToDelete)
            
            tableView.deleteRowsAtIndexPaths([indexPath],  withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }
}


// MARK: - CVCalendarViewDelegate

extension CalendarViewController: CVCalendarViewDelegate {
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        if let currentDay =  dayView.date?.day {
            if let index = dayView.weekdayIndex {
                self.todayLabel.text = weekday[index-1] + ", \(currentMonth) \(currentDay)"
            }
        }
        
        var selectedDay = dayView.date.currentDay
    
        daySchedule = []
        
        for m in monthSchedule {
            if selectedDay == m.startDate {
                daySchedule.append(m)
            }
        }
        
        selectedDate = dayView.date.convertedDate()
        
        tableView.reloadData()
    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            
            currentMonth = date.currentMonth
            let predicate = NSPredicate(format: "startDate contains[c] %@", currentMonth)
            monthSchedule = dataManager.fetch("ScheduledShift", predicate: predicate) as! [ScheduledShift]
            
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
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
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true // line separators
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        
        var currentMonth = dayView.date.currentMonth
        let predicate = NSPredicate(format: "startDate contains[c] %@", currentMonth)

        var monthSchedule = dataManager.fetch("ScheduledShift", predicate: predicate) as! [ScheduledShift]
        
//        // TODO: Optimize dotmarker generation
//        for m in monthSchedule {
//            println(m.startDate)
//        }
        
        
        let day = dayView.date.currentDay
        var shouldShowDot = false
        
        for s in monthSchedule {
            if day == s.startDate {
                shouldShowDot = true
            }
        }
        
        return shouldShowDot
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
                
        var currentMonth = dayView.date.currentMonth
        let predicate = NSPredicate(format: "startDate contains[c] %@", currentMonth)
        
        var monthSchedule = dataManager.fetch("ScheduledShift", predicate: predicate) as! [ScheduledShift]
        
//        // TODO: Optimize dotmarker generation
//        for m in monthSchedule {
//            println(m.startDate)
//        }

        
        let day = dayView.date.currentDay
        let color = UIColor.lightGrayColor()
        var numberOfDots = 0
        
        for s in monthSchedule {
            if day == s.startDate {
                numberOfDots++
            }
        }
        
        if numberOfDots == 2 {
            return [color, color]
        } else if numberOfDots >= 3 {
            return [color, color, color]
        } else {
            return [color]
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}


// MARK: - CVCalendarMenuViewDelegate

extension CalendarViewController: CVCalendarMenuViewDelegate {
    // firstWeekday() has been already implemented.
}







