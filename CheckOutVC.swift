//
//  CheckOutVC.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse


    var totalAmt = Double()

class CheckOutVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegmentedControl: UISegmentedControl!
    @IBOutlet weak var customTipbtn: UIButton!
    @IBOutlet weak var tipFieldCustomer: UITextField!
    @IBOutlet weak var noItemsLabel: UILabel!
    // Add Special Instructions indicator = reflective symbol for customer.
    
    var itemNames = [String]()
    var itemPrices = [Double]()
    
    var variantName = [String]()
    var variantPrice = [Double]()
    
    var itemObjectId = [String]()
    
    var x = 0
    var y = 0
    var t = 1
    
    var prices = [Double]()
    var loaded = true
    
    var customTipEntered = false
    var tipAmount = Double()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableview.dataSource = self
        tableview.delegate = self
        
        
        
        // We need to get tax info installed.
        taxLabel.text = ""
        
// PF Data

       callDataFromServer()
        
}
    
    func callSegueFunc () {
        performSegueWithIdentifier("gotopaymentvc", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: .Destructive, title: "Delete") { (action: UITableViewRowAction!, indexPath: NSIndexPath) -> Void in
            
            let deleteItem = self.itemObjectId[indexPath.row]
            let query = PFQuery(className: "pendingOrders")
            query.getObjectInBackgroundWithId(deleteItem) { (object, error) -> Void in
                
                if error == nil {
                    
                    object?.deleteInBackgroundWithBlock({ (result, error) -> Void in
                        if error == nil {
                            if result == true {
                                
                                self.callDataFromServer()
                                tableView.reloadData()
                            }
                        }
                    })
                }
            }

            
        }
        
        shareAction.backgroundColor = UIColor.redColor()
        return [shareAction]
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? CheckoutCell
        
        if t <= itemNames.count {
        cell?.itemTitleLabel.text = "\(t). \(itemNames[indexPath.row])"
        cell?.itemPriceLabel.text = "$\(itemPrices[indexPath.row])"
        t++
        }
        
        if x  <= (itemNames.count * 2) - 1 {
         
        
            cell?.variantTitle1.text = variantName[x]
            if variantPrice[y] == 0.0 {
            cell?.variantPrice1.text = ""
            
            } else {
            cell?.variantPrice1.text = "$\(variantPrice[y])"
            
            }
        
            x++
            y++
        
        
            cell?.variantTitle2.text = variantName[x]
            if variantPrice[y] == 0.0 {
            cell?.variantPrice2.text = ""
            
            } else {
            cell?.variantPrice2.text = "$\(variantPrice[y])"
            
            }
        
            x++
            y++
        
        
            cell?.variantTitle3.text = variantName[x]
            if variantPrice[y] == 0.0 {
            cell?.variantPrice3.text = ""
               
            } else {
            cell?.variantPrice3.text = "$\(variantPrice[y])"
               
            }
        
            x++
            y++
        
        calculateTip(1.20)
        
     }
            return cell!
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        return itemNames.count
        
        
    }
    
    
    
    @IBAction func changeTip(sender: UISegmentedControl) {
        
            if tipSegmentedControl.selectedSegmentIndex == 0 {
               calculateTip(1.0)
                tipAmount = 1.0
            }
            if tipSegmentedControl.selectedSegmentIndex == 1 {
                calculateTip(1.15)
                tipAmount = 1.15
            }
            if tipSegmentedControl.selectedSegmentIndex == 2 {
                calculateTip(1.20)
                tipAmount = 1.20
            }
            if tipSegmentedControl.selectedSegmentIndex == 3 {
                calculateTip(1.25)
                tipAmount = 1.25
        }
        
    }
    
    
    @IBAction func customTipPressed(sender: UIButton) {
        
        tipFieldCustomer.hidden = false
        customTipbtn.setTitle("calculate", forState: UIControlState.Normal)
        calculateTip(1.0)

            if tipFieldCustomer.text == "" {
                customTipEntered = false
                
        }
        if tipFieldCustomer.text != "" {
            
            let arraySum = prices.reduce(0){ $0 + $1 }
            let totalTip = arraySum + Double(tipFieldCustomer.text!)!
            let roundedTip = Double(round(100 * totalTip)/100)
            subTotal.text = "$\(roundedTip)"
            totalAmt = roundedTip + 2.0
            totalLabel.text = "$\(totalAmt)"
        }
        
}
    

    
    @IBAction func onPlaceOrderpressed(sender: UIButton) {
        
    }
    
    func updateTable () {
        
        [self.tableview.reloadData()]

        if tipFieldCustomer != "" {
            let arraySum = prices.reduce(0){ $0 + $1 }
            let totalTip = arraySum * 1.20
            let roundedTip = Double(round(100 * totalTip)/100)
            subTotal.text = "$\(roundedTip)"
            totalAmt = roundedTip + 2.0
            totalLabel.text = "$\(totalAmt)"
            tipSegmentedControl.selectedSegmentIndex = 2
        } else {
            let arraySum = prices.reduce(0){ $0 + $1 }
            let totalTip = arraySum + Double(tipFieldCustomer.text!)!
            let roundedTip = Double(round(100 * totalTip)/100)
            subTotal.text = "$\(roundedTip)"
            totalAmt = roundedTip + 2.0
            totalLabel.text = "$\(totalAmt)"
        }

        
    }
    
    func calculateTip (percentage: Double) {
        
        if loaded == true {
            let itemSum = (self.variantPrice.reduce(0){ $0 + $1 })
            let variableSum = (self.itemPrices.reduce(0){ $0 + $1 })
            
            prices = [itemSum + variableSum]
         
            loaded = false
        }
        
        
        
        let arraySum = prices.reduce(0){ $0 + $1 }
        let totalTip = arraySum * percentage
        let roundedTip = Double(round(100 * totalTip)/100)
        subTotal.text = "$\(roundedTip)"
        totalAmt = roundedTip + 2.0
        totalLabel.text = "$\(totalAmt)"
    }

    func callDataFromServer () {
        
        itemNames.removeAll(keepCapacity: true)
        itemPrices.removeAll(keepCapacity: true)
        variantName.removeAll(keepCapacity: true)
        variantPrice.removeAll(keepCapacity: true)
        
        let query = PFQuery(className: "pendingOrders")
        query.whereKey("userID", equalTo: currentUser)
        query.whereKey("restaurantID", equalTo: restid)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil && objects != nil {
                for object in objects! {
                    
                    if object["itemName"] != nil || object["itemPrice"] != nil {
                        self.itemNames.append(object["itemName"] as! String!)
                        self.itemPrices.append(object["itemPrice"] as! Double!)
                    }
                    
                    if object["variantName1"] == nil || object["variantPrice1"] == nil {
                        self.variantName.append("")
                        self.variantPrice.append(0)
                    } else {
                        self.variantName.append(object["variantName1"] as! String!)
                        self.variantPrice.append(object["variantPrice1"] as! Double!)
                    }
                    
                    if object["variantName2"] == nil || object["variantPrice2"] == nil {
                        self.variantName.append("")
                        self.variantPrice.append(0)
                    } else {
                        self.variantName.append(object["variantName2"] as! String!)
                        self.variantPrice.append(object["variantPrice2"] as! Double!)
                    }
                    
                    if object["variantName3"] == nil || object["variantPrice3"] == nil {
                        self.variantName.append("")
                        self.variantPrice.append(0)
                    } else {
                        self.variantName.append(object["variantName3"] as! String!)
                        self.variantPrice.append(object["variantPrice3"] as! Double!)
                    }
                    
                    self.itemObjectId.append(object.objectId!)
                    
                    self.tableview.reloadData()
                    
                    
                    if self.itemNames.isEmpty {
                        self.noItemsLabel.hidden = false
                    } else {
                        self.noItemsLabel.hidden = true
                    }
                    
                    self.calculateTip(self.tipAmount)
                    self.updateTable()
                    
                    
                }
            }
        }
    }
    
  
    
}
