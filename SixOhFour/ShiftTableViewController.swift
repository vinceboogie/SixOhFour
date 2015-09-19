//
//  ManualEditsShiftTableViewController.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 8/13/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class ShiftTableViewController: UITableViewController {
    
    //PASSED IN VARIABLES:
    var selectedWorkedShift : WorkedShift!
    
    //Fetched Info from passed in var.
    var dataManager = DataManager()
    var TLresults = [Timelog]()
    var JOBresults = [Job]()
    
    // NOTE Variables passed to Details
    var nItemClockIn : Timelog!
    var nItemClockInPrevious : Timelog!
    var nItemClockInNext : Timelog!
    var selectedJob : Job!
    var noMinDate = false
    var noMaxDate = false
    var selectedRowIndex = Int()
    
    // Created to handle Incomplete
    var cellIncomp: TimelogCell!
    
    var newItemCreated = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shift"
        self.tableView.rowHeight = 30.0
        fetchTLresults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        fetchTLresults()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
        println(selectedWorkedShift)
        dataManager.save()
        println("SAVED!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTLresults() {
        var predicate = NSPredicate(format: "SELF.workedShift == %@", selectedWorkedShift)
        var sortNSDATE = NSSortDescriptor(key: "time", ascending: true)
        TLresults = dataManager.fetch("Timelog", predicate: predicate, sortDescriptors: [sortNSDATE] ) as! [Timelog]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return TLresults.count
        } else if section == 2{
            if TLresults.last!.type == "Clocked Out" {
                return 0
            } else if TLresults.count % 2 == 1 {
                return 1
            } else {
                return 2
            }
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelogCell", forIndexPath: indexPath) as! TimelogCell
            cell.timelog = TLresults[indexPath.row]
            cell.jobColorView.setNeedsDisplay()
            return cell
        } else {
            cellIncomp = tableView.dequeueReusableCellWithIdentifier("TimelogCell") as! TimelogCell
            cellIncomp.time.text = "Missing Time"
            cellIncomp.jobColorView.color = TLresults[indexPath.row].workedShift.job.color.getColor
            
            if indexPath.row == 0 && (TLresults.count % 2 == 0) {
                var breakNumber : Int = (TLresults.count / 2)
                if breakNumber == 1 {
                    cellIncomp.type.text = "Ended Break"
                } else {
                    cellIncomp.type.text = "Ended Break #\(breakNumber)"
                }
            } else {
                cellIncomp.type.text = "Clocked Out"
            }
            cellIncomp.jobColorView.setNeedsDisplay()
            return cellIncomp
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var predicateJob = NSPredicate(format: "company.name == %@", (TLresults[indexPath.row].workedShift.job.company.name) )
        JOBresults = dataManager.fetch("Job", predicate: predicateJob) as! [Job]
        
        selectedJob = JOBresults[0]
        
        if indexPath.section == 1 {
            newItemCreated = 0
            nItemClockIn = TLresults[indexPath.row]
            selectedRowIndex = (indexPath.row)
            
            if (indexPath.row) == 0 {
                noMinDate = true // user select CLOCKIN so noMinDate
            } else {
                noMinDate = false
                self.nItemClockInPrevious = TLresults[indexPath.row - 1]
            }
            if (TLresults.count - indexPath.row - 1) == 0 {
                noMaxDate = true //user select last TIMELOD so noMaxDat is sent, and will use NSDATE instead
            } else {
                noMaxDate = false
                self.nItemClockInNext = TLresults[indexPath.row + 1]
            }
        } else if indexPath.section == 2 {
            
            newItemCreated = 1
            
            if indexPath.row == 1 { //clock out is sitting 2nd position so you need to add end break
                newItemCreated = 2
            }
            
            let tempTL = dataManager.addItem("Timelog") as! Timelog
            tempTL.comment = ""
            tempTL.time = (TLresults.last!.time).dateByAddingTimeInterval(1)
            
            if (indexPath.row) == 0 && TLresults.count % 2 == 0 { //you selected endbreak
                if TLresults.count < 3 {
                    tempTL.type = "Ended Break"
                } else {
                    tempTL.type = "Ended Break #\((TLresults.count)/2)"
                }
            } else { // you selected clock out
                tempTL.type = "Clocked Out"
                selectedWorkedShift.status = 0
            }
            
            nItemClockIn = tempTL
            
            noMinDate = false
            self.nItemClockInPrevious = TLresults.last
            
            noMaxDate = true
            
            // TODO : need to send up a restriction of 24hrs
        }
        self.performSegueWithIdentifier("showDetails", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    // Tableview Headers
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel.textAlignment = NSTextAlignment.Left
        
        if section == 0 {
            header.textLabel.text = "Work time = \( selectedWorkedShift.hoursWorked() ) hrs"
            header.textLabel.textColor = UIColor.blackColor()
            header.textLabel.font = UIFont.systemFontOfSize(16)
            header.textLabel.numberOfLines = 2;
        } else if section == 1 {
            header.textLabel.text = "Saved Entries:"
            header.textLabel.textColor = UIColor.blackColor()
            header.textLabel.font = UIFont.systemFontOfSize(12)
        } else if section == 2 && TLresults.last!.type != "Clocked Out" {
            header.textLabel.text = "Incomplete Entries:"
            header.textLabel.textColor = UIColor.redColor()
            header.textLabel.font = UIFont.boldSystemFontOfSize(12)
        }
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else if section == 1{
            return 35
        } else {
            return 35
        }
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        footer.textLabel.textAlignment = NSTextAlignment.Left
        if section == 0 {
            footer.textLabel.text = "You earned $\( selectedWorkedShift.moneyShiftOTx2()) for this shift"
            footer.textLabel.textColor = UIColor.blackColor()
            footer.textLabel.font = UIFont.systemFontOfSize(12)
        }
    }
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    
    // MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetails" {
            
            let destinationVC = segue.destinationViewController as! DetailsTableViewController
            destinationVC.hidesBottomBarWhenPushed = true;
            destinationVC.nItem = self.nItemClockIn
            destinationVC.nItemPrevious = self.nItemClockInPrevious
            destinationVC.nItemNext = self.nItemClockInNext
            destinationVC.noMinDate = self.noMinDate
            destinationVC.noMaxDate = self.noMaxDate
            destinationVC.selectedJob = self.selectedJob
        }
    }
    
    @IBAction func unwindShift (segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! ShiftTableViewController
        let destVC = segue.destinationViewController as! IncompleteShiftsTableViewController
        destVC.selectedWorkedShift = self.selectedWorkedShift
        dataManager.save()
        println("unwindShift")
    }
    
    @IBAction func unwindSaveDetailsTVC (segue: UIStoryboardSegue) {
        //by hitting the done button
        let sourceVC = segue.sourceViewController as! DetailsTableViewController
        TLresults[selectedRowIndex] = sourceVC.nItem
        
        selectedWorkedShift.sumUpDuration()
        selectedWorkedShift.hoursWorked()
        selectedWorkedShift.moneyShiftOTx2()
        tableView.reloadData()
        
        selectedJob = sourceVC.selectedJob
        selectedWorkedShift.job = selectedJob
        
        if newItemCreated == 1 {
            sourceVC.nItem.workedShift = selectedWorkedShift
            TLresults.append(sourceVC.nItem)
        } else if newItemCreated == 2 {
            // TODO: write code to hanle 2 new TLs
            let tempTL2 = dataManager.addItem("Timelog") as! Timelog
            tempTL2.time = TLresults.last!.time
            tempTL2.comment = ""
            if TLresults.count < 3 {
                tempTL2.type = "Ended Break"
            } else {
                tempTL2.type = "Ended Break #\((TLresults.count)/2)"
            }
            tempTL2.workedShift = selectedWorkedShift
            TLresults.append(tempTL2)
            
            sourceVC.nItem.workedShift = selectedWorkedShift
            TLresults.append(sourceVC.nItem)
        }
    }
    
    @IBAction func unwindCancelDetailsTVC (segue: UIStoryboardSegue) {
        //by hitting the done button
        let sourceVC = segue.sourceViewController as! DetailsTableViewController
        if newItemCreated > 0 {
            dataManager.delete(sourceVC.nItem)
        }
    }
}