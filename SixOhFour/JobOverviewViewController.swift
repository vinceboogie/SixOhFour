//
//  JobOverviewViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/16/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class JobOverviewViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var regularHoursLabel: UILabel!
    @IBOutlet weak var overtimeLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var weekEarningLabel: UILabel!
    @IBOutlet weak var lastThirtyDaysLabel: UILabel!
    @IBOutlet weak var yearToDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var editButton: UIBarButtonItem!
    var job: Job!
    var timelog: Timelog!
    var workedshift: WorkedShift!
    var allWorkedShifts = [WorkedShift]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editJob")
        self.navigationItem.rightBarButtonItem = editButton
        
        self.title = job.company.name
        
        let unitedStatesLocale = NSLocale(localeIdentifier: "en_US")
        let pay = job.payRate
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        numberFormatter.locale = unitedStatesLocale
        
        nameLabel.text = job.company.name
        positionLabel.text = job.position
        payLabel.text = "\(numberFormatter.stringFromNumber(pay)!)/hr"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            if indexPath.section == 0 && indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("tsCell", forIndexPath: indexPath) as! UITableViewCell
                return cell
                
            } else if indexPath.section == 0 && indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("startCell", forIndexPath: indexPath) as! UITableViewCell
                return cell
        
            } else if indexPath.section == 0 && indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier("startDateCell", forIndexPath: indexPath) as! UITableViewCell
                return cell
        
            } else if indexPath.section == 0 && indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("endCell", forIndexPath: indexPath) as! UITableViewCell
                return cell
        
            } else if indexPath.section == 0 && indexPath.row == 4 {
                let cell = tableView.dequeueReusableCellWithIdentifier("endDateCell", forIndexPath: indexPath) as! UITableViewCell
                return cell
            
        }
        return UITableViewCell()
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func fetchData() {
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "WorkedShift")
        request.returnsObjectsAsFaults = false ;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        allWorkedShifts = results as! [WorkedShift]
    }
    
    func calculateRegHours() {
        
        regularHoursLabel.text = "\(workedshift.duration)"
    }
    
    func editJob() {
        self.performSegueWithIdentifier("editJob", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editJob" {
            let destinationVC = segue.destinationViewController as! AddJobTableViewController
            destinationVC.navigationItem.title = "Edit Job"
            destinationVC.job = self.job
        }
    }
    
}