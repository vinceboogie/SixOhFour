//
//  AddJobViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/23/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class AddJobViewController: UIViewController {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var nItem : Jobs? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var payTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if nItem != nil {
            nameTextField.text = nItem?.job
            positionTextField.text = nItem?.position
            payTextField.text = nItem?.pay
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newItem() {
        let context = self.context
        let ent = NSEntityDescription.entityForName("Jobs", inManagedObjectContext: context!)
        
        let nItem = Jobs(entity: ent!, insertIntoManagedObjectContext: context)
        nItem.job = nameTextField.text
        nItem.position = positionTextField.text
        nItem.pay = payTextField.text
        context!.save(nil)
    }
    
    func editItem() {
        nItem!.job = nameTextField.text
        nItem!.position = positionTextField.text
        nItem!.pay = payTextField.text
        context!.save(nil)
        
    }
    
    @IBAction func saveJobButton(sender: AnyObject) {
        if nItem != nil {
            editItem()
        } else {
            newItem()
        }
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
    