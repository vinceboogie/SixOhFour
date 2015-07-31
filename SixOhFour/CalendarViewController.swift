//
//  CalendarViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/26/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    var shouldShowDaysOut = true
    var animationFinished = true
    var currentMonth = CVDate(date: NSDate()).currentMonth
    
    // Dummy schedule for development
    var schedule: [ScheduledShift]!
    
    let weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        schedule = [ScheduledShift]()
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
    
    
    // MARK: IB Actions
    
    @IBAction func backToCalendar(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindAfterSaveSchedule(segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! AddScheduleTableViewController
        
//        if((sourceVC.addShift) != nil) {
//            schedule.append(sourceVC.addShift)
//            tableView.reloadData()
//        }
    }
    
    
    // MARK: Table View Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedule != nil {
            return schedule.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodayScheduleCell", forIndexPath: indexPath) as! TodayScheduleCell
        
        cell.shift = schedule[indexPath.row]
        cell.jobColorView.setNeedsDisplay()
        
        return cell
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
        
        // Fetch Jobs - should look into changing later
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "ScheduledShift")
        request.returnsObjectsAsFaults = false;
        
        var startDay = dayView.date.currentDay
        
        println(startDay)
        
        let predicate = NSPredicate(format: "startDate == %@", startDay)
        
        request.predicate = predicate
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        schedule = results as! [ScheduledShift]
        
        println(schedule.count)
        
        tableView.reloadData()
    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            
            currentMonth = date.currentMonth
            
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
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date.day
        let randomDay = Int(arc4random_uniform(31))
        if day == randomDay {
            return true
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        let day = dayView.date.day
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = Int(arc4random_uniform(3) + 1)
        switch(numberOfDots) {
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color] // return 1 dot
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


//// MARK: - Convenience API Demo
//
//extension CalendarViewController {
//    func toggleMonthViewWithMonthOffset(offset: Int) {
//        let calendar = NSCalendar.currentCalendar()
//        let calendarManager = calendarView.manager
//        let components = Manager.componentsForDate(NSDate()) // from today
//        
//        components.month += offset
//        
//        let resultDate = calendar.dateFromComponents(components)!
//        
//        self.calendarView.toggleViewWithDate(resultDate)
//    }
//}








