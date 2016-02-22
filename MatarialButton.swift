//
//  MatarialButton.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 2/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class MatarialButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 10.0
        layer.shadowColor = (UIColor.grayColor()).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }


}

// Pink: E0686B
// Green : 57B754
