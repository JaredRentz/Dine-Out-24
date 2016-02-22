//
//  ItemCell.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

var count = Int()

class ItemCell: UICollectionViewCell {
    
    var timer = NSTimer()

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemtitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var addItemBtn: UIButton!
    @IBOutlet weak var addedLabel: UILabel!

    override func drawRect(rect: CGRect) {
        itemImage.clipsToBounds = true
        layer.cornerRadius = 7.0
    }
    
    @IBAction func onAddItemPressed(sender: AnyObject) {
        count += 1
        let quickItemName = "\(count). \(itemtitle.text!)"
        
        let newPrice = itemPrice.text!.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let quickItemPrice = Double(newPrice)!
        
        checkoutCart[quickItemName] = quickItemPrice
       // variantCart[""] = nil
        
        print(checkoutCart)
       // print(variantCart)
        
        self.backgroundColor = UIColor.init(red: 135, green: 135, blue: 140, alpha: 0.6)
        layer.borderColor = UIColor.redColor().CGColor
        layer.borderWidth = 1.0
        addedLabel.hidden = false
    
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "removeState", userInfo: nil, repeats: false)
        
    }
    
    func removeState() {
        addedLabel.hidden = true
    }
    
    
    
    }
