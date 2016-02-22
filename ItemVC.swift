//
//  ItemVC.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ItemVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var featuredImage: UIImageView!
    
    var menuId = [AnyObject]()
    var sendingArray2 = [AnyObject]()
    
    var itemTitle = [String]()
    var itemDescription = [String]()
    var itemPrice = [Double]()
    var itemPromoPrice = [String]()
    var itemImage = [PFFile]()
    var itemid = [String]()
    var pfUserId = PFUser()
    
    var count = 1
    var imageArray = [UIImage]()
    
    @IBOutlet weak var featuredItem: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewWillDisappear(animated: Bool) {
        sendingArray2.removeAll(keepCapacity: true)
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        pfUserId = menuId[0] as! PFUser
        let itemName = menuId[1]
        
        
        featuredItem.clipsToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        featuredItem.clipsToBounds = true
        featuredItem.layer.cornerRadius = 4.0
        
        
        
        let query = PFQuery(className: "Items")
        query.whereKey("restaurantID", equalTo: pfUserId)
        query.whereKey("category", equalTo: itemName)
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            
            if let objects = objects {
                for object in objects {
                    //print("I found Objects:\(object)")
                    
                    self.itemTitle.append(object["item"] as! String)
                    self.itemDescription.append(object["description"] as! String)
                    self.itemPrice.append(object["price"] as! Double)
                    self.itemPromoPrice.append(object["promoPrice"] as! String)
                    self.itemImage.append(object["itemImage"] as! PFFile)
                    self.itemid.append(object.objectId! as String)
                    
                    self.collectionView.reloadData()
                }
            }
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("itemcell", forIndexPath: indexPath) as? ItemCell {
            
            cell.itemtitle.text = itemTitle[indexPath.row]
            cell.itemDescription.text = itemDescription[indexPath.row]
            cell.itemPrice.text = "$\(itemPrice[indexPath.row])"
            
            if !itemImage.isEmpty {
            itemImage[indexPath.row].getDataInBackgroundWithBlock({ (data, error) -> Void in
                if let downloadedImage = UIImage(data: data!) {
                    cell.itemImage.image = downloadedImage
                    
                                    
                }
            })
        }
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemTitle.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        sendingArray2.append(itemid[indexPath.row])
        sendingArray2.append(itemTitle[indexPath.row])
        sendingArray2.append(pfUserId)
        
        
        performSegueWithIdentifier("itemdetailvc", sender: sendingArray2)
        
    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "itemdetailvc" {
            let itemdetailvc = segue.destinationViewController as! ItemDetailVC
            itemdetailvc.itemId = sender as! [AnyObject]
            
        }
        
        
    }
    
}