//
//  RestaurantVC.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

var restid: PFUser!

class RestaurantVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var geoLocation: AnyObject!
    
    
    @IBOutlet weak var tableview: UITableView!
    
    var resttitle = [String]()
    var restcatergory = [String]()
    var restaddress = [String]()
    var restdistance = [String]()
    var restwait = [String]()
    var restclose = [String]()
    var restIMG = [PFFile]()
    var objectId = [PFUser]()
    
   func dataReload () {
        tableview.reloadData()
         //print(restIMG)
    
}
    override func viewDidAppear(animated: Bool) {
         NSTimer.scheduledTimerWithTimeInterval(2.00, target: self, selector: "dataReload", userInfo: nil, repeats: false)
    }
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "callSegueFunc", name: "callSegue", object: nil)
        
        let city = geoLocation[0]
        let state = geoLocation[1]
        

        tableview.delegate = self
        tableview.dataSource = self
        
        let query = PFQuery(className:"Restaurants")
        
        if state != nil {
            let newState = state.stringByReplacingOccurrencesOfString(" ", withString: "")
            query.whereKey("restCity", equalTo:city.lowercaseString)
            query.whereKey("restState", equalTo: newState.lowercaseString)
            
        } else {
            
            query.whereKey("location", nearGeoPoint: geoLocation as! PFGeoPoint)
            query.limit = 30
            
            
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Remove All if needed
                
                if let objects = objects {
                    for object in objects {
                        
                        
                        self.resttitle.append(object["restName"] as! String)
                        self.restcatergory.append(object["restCategory"] as! String)
                        self.restaddress.append(object["restStreet"] as! String)
                        self.restdistance.append(object["restZip"] as! String)
                        self.restwait.append(object["restWaittime"] as! String)
                        self.restclose.append(object["restClose"] as! String)
                        self.objectId.append(object["restaurantID"] as! PFUser)
                        self.restIMG.append(object["image"] as! PFFile)
                        self.tableview.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
       


    }
    
    func callSegueFunc () {
        performSegueWithIdentifier("restaurantdetailvc", sender: self)
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("restaurantcell") as? RestaurantCell
       
        
        
        if resttitle == [] {
            tableview.reloadData()
            
        } else {
            
            
            cell?.restaurantTitle.text = resttitle[indexPath.row]
            cell?.restaurantCategory.text = restcatergory[indexPath.row]
            cell?.restaurantAddress.text = restaddress[indexPath.row]
            cell?.restaurantDistance.text = restdistance[indexPath.row]
            cell?.restaurantWaitTime.text = restwait[indexPath.row]
            cell?.restaurantCloses.text = restclose[indexPath.row]
            
            restIMG[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
                
                if let downloadedImage = UIImage(data: data!) {
                    
                    cell?.restaurantIMG.image = downloadedImage
                }
                
            }

            
    }
        
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resttitle.count
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        restid = objectId[indexPath.row]
        
        performSegueWithIdentifier("menuvc", sender: restid)
        
    }
   
    
    }

