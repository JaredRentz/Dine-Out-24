//
//  HomeScreenVC.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse


class HomeScreenVC: UIViewController {
    
    var userLocation: PFGeoPoint!

    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        searchField.text = ""
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutPressed(sender: AnyObject) {
        
        PFUser.logOut()
        currentUser = PFUser.currentUser()
    }

    @IBAction func onCurrentLocation(sender: AnyObject) {
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint, error) -> Void in
            
            if error == nil {
               self.userLocation = geoPoint
                self.searchField.text = ""
                self.searchField.tintColor = UIColor.redColor()
            
                let currentLocation = self.userLocation
                self.performSegueWithIdentifier("restaurantvc", sender: currentLocation)
                
            } else {
                self.alert("Im Sorry About That", message: "Looks like theres a connection problem")
            }
        }
    }
    
    @IBAction func onSearchPressed(sender: UIButton) {
        
        if searchField.text == ""  {
           alert("Eh...", message: "Please enter a City and State")

        } else {
            
            let citysearch = searchField.text?.componentsSeparatedByString(",")
            
            if citysearch!.count < 2 {
                alert("Sorry", message: "Enter the City and State again!")
            } else {
                
                
                
                let city = citysearch![0]
                let state = citysearch![1]
                
                
                let newState = state.stringByReplacingOccurrencesOfString(" ", withString: "")
                
                let query = PFQuery(className: "Restaurants")
                query.whereKey("restCity", equalTo: city.lowercaseString)
                query.whereKey("restState", equalTo: newState.lowercaseString)
                
                
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if error == nil {
                    
                    if objects?.count >= 1 {
                        
                        self.performSegueWithIdentifier("restaurantvc", sender: citysearch)
                        
                    } else {
                        self.alert("Sorry!", message: "We aren't serving your city yet")
                    }
                    
                } else {
                self.alert("There was an Error", message: "Please Try Again.")
                    
                }
                })
                
                

                
            }
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "restaurantvc" {
            let restaurantvc: RestaurantVC = (segue.destinationViewController as? RestaurantVC)!
            restaurantvc.geoLocation = sender! as AnyObject
            
        }
    }
    
    func alert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
  
}
