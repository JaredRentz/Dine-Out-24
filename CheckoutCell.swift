//
//  CheckoutCell.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class CheckoutCell: UITableViewCell {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var variantTitle1: UILabel!
    @IBOutlet weak var variantTitle2: UILabel!
    @IBOutlet weak var variantTitle3: UILabel!
    
    @IBOutlet weak var variantPrice1: UILabel!
    @IBOutlet weak var variantPrice2: UILabel!
    @IBOutlet weak var variantPrice3: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func OnDeletePressed(sender: AnyObject) {
       
        
        
        
        
        
    NSNotificationCenter.defaultCenter().postNotificationName("updateCheckout", object: self)
 }
    

}
