//
//  PayRateViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/2/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

@objc protocol writeValueBackDelegate {
    func writeValueBack(vc: PayRateViewController, value: String)
}

class PayRateViewController: UIViewController {
    
    var writeValueDelegate: writeValueBackDelegate?

    @IBOutlet weak var payTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        if let delegate = writeValueDelegate {
            delegate.writeValueBack(self, value: payTextField.text)
            println("writingValueBack")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

}
