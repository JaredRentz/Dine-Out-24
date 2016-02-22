//
//  MenuVC.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse



class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var object: PFUser!
    

    var sendingArray = [AnyObject]()
    
    @IBOutlet weak var tableview: UITableView!
    
    var menuimg = [PFFile]()
    var menutitle = [String]()
    var objectId = [PFUser]()
    var imageFile = [PFFile]()
    
    override func viewWillDisappear(animated: Bool) {
        sendingArray.removeAll(keepCapacity: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = theName
        
        tableview.delegate = self
        tableview.dataSource = self
        // Do any additional setup after loading the view.
        
        let query = PFQuery(className: "Categories")
        
        if restid != nil {
           
            query.whereKey("restaurantID", equalTo: restid)
           query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects {
                for object in objects {
                    
                    self.menutitle.append(object["category"] as! String)
                    self.objectId.append(object["restaurantID"] as! PFUser)
                    
                    if object["categoryImage"] as! PFFile == "" {
                    // Need a default image
                    } else {
                    self.imageFile.append(object["categoryImage"] as! PFFile)
                    }
                    self.tableview.reloadData()
                }
            }
        }
        
    } else {
            if object != nil {
                
                query.whereKey("restaurantID", equalTo: object)
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    
                    if let objects = objects {
                        for object in objects {
                            
                            self.menutitle.append(object["category"] as! String)
                            self.objectId.append(object["restaurantID"] as! PFUser)
                            self.imageFile.append(object["categoryImage"] as! PFFile)
                            
                            self.tableview.reloadData()
                        }
                    }
                })
                
            }
            
        }
    }


    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("menucell") as? MenuCell
        
       
        
        if menutitle == [] {
            self.tableview.reloadData()
        } else {
            
            cell?.menuTitle.text = menutitle[indexPath.row]
            
         
            if !imageFile.isEmpty {
                
                imageFile[indexPath.row].getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if let downloadedImage = UIImage(data: data!) {
                        cell?.menuIMG.image = downloadedImage
                    }
                    
                })

                
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menutitle.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sendingArray.append(objectId[indexPath.row]) //=  objectId[indexPath.row] as PFUser
        sendingArray.append(menutitle[indexPath.row]) //menutitle[indexPath.row] as String
        performSegueWithIdentifier("itemvc", sender: sendingArray)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "itemvc" {
            let itemvc: ItemVC = (segue.destinationViewController as? ItemVC)!
            itemvc.menuId = sender as! Array
        }
    }
}
