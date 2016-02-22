//
//  Restaurant.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Parse


class Restaurant {
    private var _restaurantTitle: String!
    private var _postKey: String!
    
    
    
    var restaurantTitle: String! {
        return _restaurantTitle
    }
    
    
    init( restaurantTitle: String) {
        self ._restaurantTitle = restaurantTitle
    }
    
   }





