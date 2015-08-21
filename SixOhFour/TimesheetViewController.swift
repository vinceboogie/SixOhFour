//
//  TimesheetViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/24/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class TimesheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var days: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var hours: [String] = ["8.0", "8.4", "4.6", "8.3", "8.4", "5.6", "8.5"]
    
    @IBOutlet weak var regularHoursLabel: UILabel!
    @IBOutlet weak var overtimeHoursLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var earningsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimesheetCell", forIndexPath: indexPath) as! TimesheetCell

        cell.dayLabel.text = self.days[indexPath.row]
        cell.hoursLabel.text = self.hours[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
