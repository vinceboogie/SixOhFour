//
//  AddJobViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/23/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class AddJobViewController: UIViewController, writeValueBackDelegate {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var nItem : Jobs? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var payRateLabel: UILabel!
    var payRateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if nItem != nil {
            nameTextField.text = nItem?.job
            positionTextField.text = nItem?.position
            payRateLabel.text = nItem?.pay
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func writeValueBack(vc: PayRateViewController, value: String) {
        self.payRateLabel.text = "$\(value)"
    }
    
    func newItem() {
        let context = self.context
        let ent = NSEntityDescription.entityForName("Jobs", inManagedObjectContext: context!)
        
        let nItem = Jobs(entity: ent!, insertIntoManagedObjectContext: context)
        nItem.job = nameTextField.text
        nItem.position = positionTextField.text
        nItem.pay = payRateLabel.text!
        context!.save(nil)
    }
    
    func editItem() {
        nItem!.job = nameTextField.text
        nItem!.position = positionTextField.text
        nItem!.pay = payRateLabel.text!
        context!.save(nil)
    }
    
    @IBAction func saveJobButton(sender: AnyObject) {
        if nItem != nil {
            editItem()
        } else {
            newItem()
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func payRateButtonPressed(sender: AnyObject) {
        let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
        var payRateViewController: PayRateViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("PayRateViewController") as! PayRateViewController
        payRateViewController.writeValueDelegate = self
        navigationController?.pushViewController(payRateViewController, animated: true)
    }
    
}
    