//
//  JobsListTableViewController.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/10/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class JobsListTableViewController: UITableViewController {

    var jobName: String!
    var jobColor: UIColor!
    var selectedJob: Job!
    var previousSelection: String!

    var jobsList = [Job]()
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsList = dataManager.fetch("Job") as! [Job]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JobsListCell", forIndexPath: indexPath) as! JobsListCell
        
        cell.jobNameLabel.text = jobsList[indexPath.row].company.name
        
        cell.jobColorView.color = jobsList[indexPath.row].color.getColor
        
        if cell.jobNameLabel.text == previousSelection {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedJob = jobsList[indexPath.row]
                
        self.performSegueWithIdentifier("unwindFromJobsListTableViewController", sender: self)
    }
}
