//
//  LoginViewController.swift
//  ChainChatiOS
//
//  Created by Jeremy Francispillai on 2014-09-20.
//  Copyright (c) 2014 Jeremy Francispillai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var validLogin:Bool = false
    
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
        password.text = ""
        PFUser.logOut()
    }
    
    
    
    @IBAction func login(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(username.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), password:password.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                println("Login worked")
                self.validLogin = true
                self.performSegueWithIdentifier("successfulLogin", sender: self)
            } else {
                println("login failed")
                self.validLogin = false
            }
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        var worked:Bool = true
        
        var newUser = PFUser()
        newUser.username = username.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        newUser.password = password.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        newUser.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                worked = true
                println("worked")
            } else {
                //let errorString = error.userInfo["error"] as NSString
                worked = false
                println("didn't work")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool{
        
        //return true
        
        if identifier == "loginSuccessful" {
            
            PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    println("Login worked")
                    self.validLogin = true
                    
                } else {
                    println("login failed")
                    self.validLogin = false
                }
            }
            println("\(validLogin)")
            
            if !validLogin {
                return false
            }
            
        }
        
        return true
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
