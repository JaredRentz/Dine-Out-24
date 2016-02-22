//
//  ItemDetailVC.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

var checkoutCart = [String:Double]()
var checkoutCart1 = [String:Double]()

class ItemDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var itemId = [AnyObject]()
    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    var itemImage: PFFile!
    
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishDescription: UILabel!
    @IBOutlet weak var specialInstructions: UITextView!
    @IBOutlet weak var allergies: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var addItemBtn: UIButton!
    @IBOutlet weak var itemAddedLabel: UILabel!
 
    var variantTitle = [String]()
    var variantPrice = [Double]()

    
    var itemPrice: Double!
    var itemName: String!
    
    var names = [String]()
    var prices = [Double]()
    
    var timer = NSTimer()
    
    override func viewDidAppear(animated: Bool) {
        
        tableview.reloadData()
    }

    
    override func viewWillDisappear(animated: Bool) {
        itemId.removeAll()
        checkoutCart.removeAll(keepCapacity: true)
        checkoutCart1.removeAll(keepCapacity: true)
        
       
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        let itemid = itemId[0]
        let itemtitle = itemId [1]
        let restaurantid = itemId[2]

        
        itemImg.clipsToBounds = true
        
        tableview.delegate = self
        tableview.dataSource = self
        
// Back Button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton;
        
// Variants
        
        let query = PFQuery(className: "Variants")
        query.whereKey("restaurantID", equalTo: restaurantid)
        query.whereKey("dishName", equalTo:itemtitle)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects {
                for object in objects {
                    
                    
                    if object["itemName1"] != nil || object["itemPrice1"] != nil {
                        self.variantTitle.append(object["itemName1"] as! String)
                        self.variantPrice.append(object["itemPrice1"] as! Double)
                    }
                    
                    if object["itemName2"] != nil || object["itemPrice2"] != nil {
                        self.variantTitle.append(object["itemName2"] as! String)
                        self.variantPrice.append(object["itemPrice2"] as! Double)
                    }
                    
                    if object["itemName3"] != nil || object["itemPrice3"] != nil {
                        self.variantTitle.append(object["itemName3"] as! String)
                        self.variantPrice.append(object["itemPrice3"] as! Double)
                    }
                    
                    

                    self.tableview.reloadData()
                }
            }
        }
        
        
        // Items
        
        let iQuery = PFQuery(className: "Items")
        iQuery.getObjectInBackgroundWithId(itemid as! String) { (objects, error) -> Void in
            
            if error == nil {
                
                self.dishName.text = objects!["item"] as? String
                self.dishPrice.text = "$\(objects!["price"] as! Double)"
                self.dishDescription.text = objects!["description"] as? String
                self.allergies.text = objects!["allergies"] as? String
                
                self.itemPrice = objects!["price"] as? Double
                self.itemName = objects!["item"] as? String
                
                self.itemImage = objects!["itemImage"] as! PFFile
                
                if self.itemImg != nil {
                   self.itemImage.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    
                    if let downloadedData = UIImage(data: data!) {
                        self.itemImg.image = downloadedData
                    }
                    
                   })
                }
                
            } else {
                self.alert("Sorry about that", message: "Connection Error")
            }
        }
}
    
// Back Button - Function:
    
    func back(sender: UIBarButtonItem) {
        
        if !checkoutCart.isEmpty{
            // Go back to the previous ViewController
            self.navigationController?.popViewControllerAnimated(true)
            checkoutCart.removeAll(keepCapacity: true)
        }

        // Go back to the previous ViewController
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell1") as? ItemDetailCell {
           
            
            cell.itemlabel1.text = variantTitle[indexPath.row]
            cell.itemPrice.text = "$\(variantPrice[indexPath.row])"
            
            
           
            
            return cell
            
        } else {
            return ItemDetailCell()
        }
        
           
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return variantTitle.count
    }

    
    
    @IBAction func addItemToCart(sender: AnyObject) {
        
// - Save data to server
        count = 1
        checkoutCart1["\(itemName)"] = itemPrice
        
       addItemBtn.backgroundColor = UIColor.init(red: 135, green: 135, blue: 140, alpha: 0.8)
        itemAddedLabel.hidden = false
        itemAddedLabel.layer.cornerRadius = 7.0
        itemAddedLabel.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "removeState", userInfo: nil, repeats: false)
        
        
        if !checkoutCart1.keys.isEmpty {
        
        let itemNameC = [String] (checkoutCart1.keys)
        let itemPriceC = [Double] (checkoutCart1.values)
         
            if !checkoutCart.isEmpty {
                names = [String] (checkoutCart.keys)
                prices = [Double] (checkoutCart.values)
            }
    
        let postQuery = PFObject(className: "pendingOrders")
        postQuery["itemName"] = itemNameC[0]
        postQuery["itemPrice"] = itemPriceC[0]
        
        if restid != "" {
            postQuery["restaurantID"] = restid
        }
        
        if currentUser != "" {
            postQuery["userID"] = currentUser
        }
        
        
        if specialInstructions != "" {
          postQuery["specialInstructions"] = specialInstructions.text
        }
        
        
        // Future Upgrades
        
        //postQuery["flavorRating"] = flavorRating.text //0=none 1=dash 2=medium 3=full flavor
        //postQuery["SpicyRating"] = flavorRating.text  //0=none 1=dash 2=medium 3=full flavor
        
        if (names.count >= 1) {
            postQuery["variantName1"] = names[0]
            postQuery["variantPrice1"] = prices[0]
        }
        
        if (names.count >= 2) {
            postQuery["variantName2"] = names[1]
            postQuery["variantPrice2"] = prices[1]
        }
        
        if (names.count >= 3) {
            postQuery["variantName3"] = names[2]
            postQuery["variantPrice3"] = prices[2]
        }
            
            if (names.count >= 1) {
            postQuery["itemsArray"] = names[0]
            postQuery["pricesArray"] = prices[0]
            } else {
                let name = []
                postQuery["itemsArray"] = name
                let price = [0]
                postQuery["pricesArray"] = price
            }
        
            if (names.count >= 2) {
                postQuery["itemsArray"] = names[1]
                postQuery["pricesArray"] = prices[1]
            } else {
                let name = []
                postQuery["itemsArray"] = name
                let price = [0]
                postQuery["pricesArray"] = price
            }
            
            if (names.count >= 3) {
                postQuery["itemsArray"] = names[2]
                postQuery["pricesArray"] = prices[2]
            } else {
                let name = []
                postQuery["itemsArray"] = name
                let price = [0]
                postQuery["pricesArray"] = price
            }
            
        
        
        
    
        postQuery.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if error == nil  {
                self.alert("Perfect!", message: "Your request has been added")
            } else {
                self.alert("Sorry", message: "Could not save data")
            }
        }
    
    }
       performSegueWithIdentifier("backtomenu", sender: nil)
        
}
    

    func removeState() {
       itemAddedLabel.hidden = true
    }
    
    func alert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
       
}
