/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

var currentUser: PFUser!

class ViewController: UIViewController {
    
    var signupActive = true
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var alreadyRegisterdLabel: UILabel!
    @IBOutlet weak var loginLabel: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    
    
    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            
            currentUser = PFUser.currentUser()
            self.performSegueWithIdentifier(LOGIN_SEGUE, sender: self)
        }
    }
    
    
    @IBAction func onSignUpPressed(sender: UIButton) {
        
        if usernameField.text == "" || passwordField.text == "" {
            
            
            
            if #available(iOS 8.0, *) {
            
                let alert = UIAlertController(title: "Error in Form", message: "Please enter a username and password", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                // Fallback on earlier versions
            }
            
            
            
           
            
        } else {
            
            
            
            // Spinner called if we need to proccess a request
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signupActive == true {
                
            
            
            // IF not then add user info to Parse database
            
            signupUser()
            
            
            } else {
                
                if signupActive == false {
                    
                    PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!, block: { (user, error) -> Void in
                        
                        if user != nil {
                            
                           
                            // User as a username
                            self.performSegueWithIdentifier(LOGIN_SEGUE, sender: self)
                            self.activityIndicator.stopAnimating()
                          
                            
                        } else {
                            
                            // Theres an error
                            
                            print("There is an error")
                            self.alertBox("Eh Eh Eh", message: "Sorry Try Again!")
                            
                        }
                    })
                }
                
                
            }
        
        }
        
    }
    
    @IBAction func onLoginPressed(sender: UIButton) {
        
        if signupActive == true {
            firstNameField.hidden = true
            lastNameField.hidden = true
            signupButton.setTitle("Login", forState: .Normal)
            alreadyRegisterdLabel.text = "Need to Register?"
            loginLabel.setTitle("Register", forState: .Normal)
            signupActive = false
            usernameField.text = ""
            passwordField.text = ""
            firstNameField.text = ""
            lastNameField.text = ""
            alreadyRegisterdLabel.text = "Already Registered"
            forgotPassword.hidden = false
            
            
        } else {
            
            if signupActive == false {
                firstNameField.hidden = false
                lastNameField.hidden = false
                
                signupButton.setTitle("Sign Up", forState: .Normal)
                loginLabel.setTitle("Login", forState: .Normal)
                signupActive = true
                usernameField.text = ""
                passwordField.text = ""
                
                
            }
        }
        
        
    }
    
    func signupUser () {
        
        let user = PFUser()
        
        var errorMessage = "There was an Error Try Again"
        
        user.username = usernameField.text
        user.password = passwordField.text
        user["firstname"] = firstNameField.text
        user["lastname"] = lastNameField.text
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            
            if error == nil {
                
                self.performSegueWithIdentifier(LOGIN_SEGUE, sender: self)
                self.activityIndicator.stopAnimating()
                // Sign in and go to next page
                
            } else {
                
                if let errorString = error?.userInfo["error"] as? String {
                  
                    errorMessage = errorString
                    
                    self.alertBox("Error", message: errorMessage)
                    
                }
                
            }
            
            
        }
        
        
    }
    
    func alertBox (title: String, message: String) {
        
        
        if #available(iOS 8.0, *) {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                

            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            passwordField.text = ""
            activityIndicator.stopAnimating()
            
           
    }
    }
    
  
    
}
