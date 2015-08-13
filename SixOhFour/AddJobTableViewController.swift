//
//  AddJobTableViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/9/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class AddJobTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var payRateLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var jobColorView: JobColorView!
    @IBOutlet weak var saveJobButton: UIBarButtonItem!

    var job: Job!
    var pickerVisible = false
    var payRate: NSDecimalNumber!
    
    let dataManager = DataManager()
    var colors = [Color]()
    
    // DELETE: Review and delete
    // We're now fetching the prepopulated Color table and using that for our picker.
//    let pickerData = ["Red", "Magenta", "Purple", "Blue", "Cyan", "Green", "Yellow", "Orange", "Brown", "Gray"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colors = dataManager.fetch("Color") as! [Color]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        colorPicker.dataSource = self
        colorPicker.delegate = self
        
        if job != nil {
            let unitedStatesLocale = NSLocale(localeIdentifier: "en_US")
            let pay = job.payRate
            var numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            numberFormatter.locale = unitedStatesLocale
            
            nameTextField.text = job.company.name
            positionTextField.text = job.position
            payRateLabel.text = numberFormatter.stringFromNumber(pay)!
            
            payRate = job.payRate
            colorLabel.text = job.color.name
            jobColorView.color = job.color.getColor
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if nameTextField.text == "" {
            self.navigationItem.rightBarButtonItem!.enabled = false
        }
        
        nameTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        // DELETE: Review and Delete
//        var selectedColor = 0
//
//        for var i = 0; i < pickerData.count; i++ {
//            var color = colorLabel.text!
//            if pickerData[i] == color {
//                selectedColor = i
//            }
//        }
//
//        colorPicker.selectRow(selectedColor, inComponent: 0, animated: true)
        
        
        // so fresh and so clean :]
        if job != nil {
            let selectedColor = find(colors, job.color)
            colorPicker.selectRow(selectedColor!, inComponent: 0, animated: true)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func saveJobButton(sender: AnyObject) {
        if job != nil {
            editItem()
        } else {
            newItem()
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func unwindFromPayRateTableViewController(segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! PayRateTableViewController
        payRateLabel.text = "\(sourceVC.payTextField.text)"
        
        var str = sourceVC.payTextField.text
        str = str.stringByReplacingOccurrencesOfString(",", withString: "")
        str = str.stringByReplacingOccurrencesOfString("$", withString: "")
        
        print("str ")
        println(str)
        
        payRate = NSDecimalNumber(string: str)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    // MARK: -  Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            pickerVisible = !pickerVisible

            tableView.reloadData()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 4 {
            if pickerVisible == false {
                return 0.0
            }
            return 150.0
        }
        return 44.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newItem() {
        
        // DELETE: Review and delete
        // Now using DataManager class
//        let context = self.context
//        let ent = NSEntityDescription.entityForName("Job", inManagedObjectContext: context!)
//        let com = NSEntityDescription.entityForName("Company", inManagedObjectContext: context!)
//        let col = NSEntityDescription.entityForName("Color", inManagedObjectContext: context!)
//
//        let company = Company(entity: com!, insertIntoManagedObjectContext: context)
//        let color = Color(entity: col!, insertIntoManagedObjectContext: context)
//        let job = Job(entity: ent!, insertIntoManagedObjectContext: context)
        
        
        
        // TODO: let color is creating a new managedObj. 
        // We need to fetch the color and link jobs to it.
        // Also, we should pass job.position to coredata instead of positionTextField.text
        
        let company = dataManager.addItem("Company") as! Company
        let color = dataManager.addItem("Color") as! Color
        let job = dataManager.addItem("Job") as! Job
        
        company.name = nameTextField.text
        color.name = colorLabel.text!
    
        job.setValue(company, forKey: "company")
        job.position = positionTextField.text
        job.setValue(color, forKey: "color")
        
        if payRate == nil {
            job.payRate = 0.00
        }

        dataManager.save()
    }
    
    func editItem() {

        // DELETE: Review and delete
        // Now using the Datamanager class
        // Make sure edits are being saved/done properly
//
//        job.company.name = nameTextField.text
//        job.position = positionTextField.text
//        job.payRate = payRate
//        job.color.name = colorLabel.text!
//        
//        context!.save(nil)
        
        let editJob = dataManager.editItem(job, entityName: "Job") as! Job
        
        editJob.company.name = nameTextField.text
        editJob.position = positionTextField.text
        editJob.payRate = payRate
        editJob.color.name = colorLabel.text!
        
        dataManager.save()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "payRate" {
            let destinationVC = segue.destinationViewController as! PayRateTableViewController
            destinationVC.job = self.job
        }
    }
    
}


// MARK: - Picker Data Source and Delegate

extension AddJobTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // DELETE: Review and Delete
//        return pickerData.count
        return colors.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        // DELETE: Review and Delete
//        return pickerData[row]
        return colors[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // DELETE: Review and Delete
//        colorLabel.text = pickerData[row]
//        jobColorView.color = jc.getJobColor(pickerData[row])
//        jobColorView.setNeedsDisplay()
        
        colorLabel.text = colors[row].name
        jobColorView.color = colors[row].getColor
        jobColorView.setNeedsDisplay()
    }

}

// MARK: - TextField Delegate

extension AddJobTableViewController: UITextFieldDelegate {
    
    func textFieldDidChange(textField: UITextField) {
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        if textField.text.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
            self.navigationItem.rightBarButtonItem!.enabled = true
        }
    }
    
}