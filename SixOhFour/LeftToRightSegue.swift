//
//  LeftToRightSegue.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/1/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class LeftToRightSegue: UIStoryboardSegue {

    // TESTING CUSTOM SEGUES
    
    override func perform() {
        
        var sourceViewController: UIViewController = self.sourceViewController as! UIViewController
        var destinationViewController: UIViewController = self.destinationViewController as! UIViewController
        
        let sourceView = sourceViewController.view
        let destinationView = destinationViewController.view

        if let containerView = sourceView.superview {
            let initialFrame = sourceView.frame
            var offscreenRect = initialFrame
            offscreenRect.origin.x += CGRectGetWidth(initialFrame)
            destinationView.frame = offscreenRect
            containerView.addSubview(destinationView)
            
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 4.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                destinationView.frame = initialFrame
                }, completion: { finished in
                    destinationView.removeFromSuperview()
                    sourceViewController.presentViewController(destinationViewController, animated: false, completion: nil)
            })
        }
    }
}
