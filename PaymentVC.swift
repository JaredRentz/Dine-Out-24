//
//  PaymentVC.swift
//  DineIn_Customer
//
//  Created by Jared Rentz on 1/31/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Stripe


class PaymentVC: UIViewController {

    @IBOutlet weak var cardTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var cvvTxt: UITextField!
    @IBOutlet weak var saveButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }

    @IBAction func payBtn_Click(sender: AnyObject) {
        
        let creditCard = STPCardParams()
        
        creditCard.number = cardTxt.text
        creditCard.cvc = cvvTxt.text
        
        if dateTxt.text != nil {
            
            let expArr = dateTxt.text?.componentsSeparatedByString("/")
            if expArr!.count > 1 {
                
                let expMonth: NSNumber = Int(expArr![0])!
                let expYear: NSNumber = Int(expArr![1])!
                
                creditCard.expMonth = expMonth.unsignedLongValue
                creditCard.expYear = expYear.unsignedLongValue
            }
        }
        
        STPAPIClient.sharedClient().createTokenWithCard(creditCard) { (token, StripeError) -> Void in
            
            if StripeError == nil {
                print(token!.tokenId)
                
                self.sendTokenToServer(token!.tokenId)
                
            } else {
                print(StripeError?.localizedDescription)
            }
        }
    }
    
    func sendTokenToServer (tokenId: String) {
        
        let amount = 120 //totalAmt
        let productType = "Jared Test"
        let holderName = "Jared"
        
        let priceToDouble = amount * 100
        
        let priceToInt = Int(priceToDouble)
        
        let amountStr = "\(priceToInt)"
        
        //http://jaredrentz.com/stripe-php/token.php
        let url = NSURL(string: "http://jaredrentz.com/stripe-php/token.php")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let body = "stripeToken=\(tokenId)&amount=\(amountStr)&type=\(productType)&name=\(holderName)"
        
        print(body)
        
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error == nil {
                
                
                do {
                    let jsonResults:NSDictionary? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    
                    let jsonComp = jsonResults?.valueForKey("completion") as! String
                    
                    print(jsonComp)
                    
                } catch {
                    print(error)
                   
                }
                
            } else {
                print(response)
                print(error)
            }
        }
    }
   
}



