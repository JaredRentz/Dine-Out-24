//
//  BeaconMenuVC.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 2/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class BeaconMenuVC: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ibeaconFoundReceivedNotification:", name: "ibeaconFoundReceivedNotification", object: nil)
        
    }

    func ibeaconFoundReceivedNotification (notification: NSNotification) {
        
        // Take action from notification
        
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            
            let major = userInfo["major"]!
            let minor = userInfo["minor"]!
            
            NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: "removeLabel", userInfo: nil, repeats: false)
            
            // Now for Action: We can set up a pop-up alert.
            
            let messageinfo = "... Loading the Menu"
            
            let alert = UIAlertController(title: "Got it!", message: messageinfo, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            // Webview Action (interchangeable)
            
            let urlString = "http://bonterradining.com/dinner"
            
            let url = NSURL(string: urlString)
            let requestObject = NSURLRequest(URL: url!)
            webView.loadRequest(requestObject)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func removeLabel () {
        textLabel.hidden = true
    }


    

}
