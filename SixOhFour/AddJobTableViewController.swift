//
//  AddJobTableViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/9/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class AddJobTableViewController: UITableViewController, writeValueBackDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var payRateLabel: UILabel!
    
    @IBAction func payRateButtonPressed(sender: AnyObject) {
        let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
        var payRateTableViewController: PayRateTableViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("PayRateTableViewController") as! PayRateTableViewController
        payRateTableViewController.writeValueDelegate = self
        navigationController?.pushViewController(payRateTableViewController, animated: true)
    }
    
    @IBAction func saveJobButton(sender: AnyObject) {
        if nItem != nil {
            editItem()
        } else {
            newItem()
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var nItem : Jobs? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if nItem != nil {
            nameTextField.text = nItem?.jobName
            positionTextField.text = nItem?.jobPosition
            payRateLabel.text = nItem?.jobPay
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func writeValueBack(vc: PayRateTableViewController, value: String) {
        self.payRateLabel.text = "$\(value)"
    }
     
    
    func newItem() {
        let context = self.context
        let ent = NSEntityDescription.entityForName("Jobs", inManagedObjectContext: context!)
            
        let nItem = Jobs(entity: ent!, insertIntoManagedObjectContext: context)
        nItem.jobName = nameTextField.text
        nItem.jobPosition = positionTextField.text
        nItem.jobPay = payRateLabel.text!
        context!.save(nil)
    }
        
    func editItem() {
        nItem!.jobName = nameTextField.text
        nItem!.jobPosition = positionTextField.text
        nItem!.jobPay = payRateLabel.text!
        context!.save(nil)
    }

}
