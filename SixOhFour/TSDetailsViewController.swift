//
//  TSDetailsViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/30/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class TSDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var tableView: UITableView!
    
    var entryType: [String] = ["Clock In", "Start Break", "End Break", "Clock Out"]
    var timestamps = [Timelog]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entryType.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailsCell", forIndexPath: indexPath) as! DetailsCell
        
        cell.textLabel?.text = entryType[indexPath.row]
//        cell.detailTextLabel?.text = timestamps[indexPath.row].time
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
