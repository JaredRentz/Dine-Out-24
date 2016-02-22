//
//  RestaurantDetailVC.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

var theName = ""

class RestaurantDetailVC: UIViewController {

    @IBOutlet weak var restIMG: UIImageView!
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var restCategory: UILabel!
    @IBOutlet weak var restStreet: UILabel!
    @IBOutlet weak var restDistance: UILabel!
    @IBOutlet weak var restOpen: UILabel!
    @IBOutlet weak var restClose: UILabel!
    
    var restID: PFUser!
    var imageFile: PFFile!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "Restaurants")
        query.whereKey("restName", equalTo: theName)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects {
                for object in objects {
                   
                    self.restName.text = object["restName"] as? String
                    self.restCategory.text = object["restCategory"] as? String
                    self.restStreet.text = object["restStreet"] as? String
                    self.restDistance.text = object["restDistance"] as? String
                    self.restOpen.text = object["restOpen"] as? String
                    self.restClose.text = object["restClose"] as? String
                    self.imageFile = object["image"] as? PFFile
                    //self.restIMG.image = UIImage(named: "Burger1.jpg")
                    
                    self.restID = object["restaurantID"] as? PFUser
                    // Download images
                    if self.imageFile != nil {
                        self.imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                            if let downloadedImage = UIImage(data: data!) {
                                self.restIMG.image = downloadedImage
                            }
                        }
                        
                    }

                }
            }
        }
        
        
    }

    @IBAction func onCallPressed(sender: AnyObject) {

        let url = NSURL(string: "tel://7813912708")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func onGoToMenuPressed(sender: UIButton) {
    
        performSegueWithIdentifier("gotomenuvc", sender: restID)
   
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotomenuvc" {
            if let menuvc: MenuVC = segue.destinationViewController as? MenuVC {
                menuvc.object = sender as! PFUser!
                
            }
        }
    }
    

}
