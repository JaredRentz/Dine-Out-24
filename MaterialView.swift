//
//  MaterialView.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 2/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = (UIColor.grayColor()).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}
