//
//  ItemDetailCell.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit



class ItemDetailCell: UITableViewCell {

   
    @IBOutlet weak var itemlabel1: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var addItem: UIButton!
    
    var removeAvailable = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {

                let price = Double((itemPrice.text?.stringByReplacingOccurrencesOfString("$", withString: ""))!)
                
                let name = "\(itemlabel1.text!)"
                
                checkoutCart[name] = price
                
                addItem.setTitle("-", forState: .Normal)
                addItem.tintColor = UIColor.redColor()
            
     
    }
    

}
