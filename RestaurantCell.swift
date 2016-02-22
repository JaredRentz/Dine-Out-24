//
//  RestaurantCell.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var restaurantIMG: UIImageView!
    @IBOutlet weak var restaurantTitle: UILabel!
    @IBOutlet weak var restaurantCategory: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantDistance: UILabel!
    @IBOutlet weak var restaurantWaitTime: UILabel!
    @IBOutlet weak var restaurantCloses: UILabel!
    @IBOutlet weak var moreDetails: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        restaurantIMG.clipsToBounds = true
 
    }
    
    override func drawRect(rect: CGRect) {
        restaurantIMG.clipsToBounds = true
        //restaurantIMG.layer.cornerRadius = 12.0
    }
     
    @IBAction func onMoreDetailPressed(sender: UIButton) {
        
        theName = restaurantTitle.text!
        
    NSNotificationCenter.defaultCenter().postNotificationName("callSegue", object: self)
    }

}
