//
//  LoginViewController.swift
//  On the Map
//
//  Created by Olivia Murphy on 8/13/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var warningTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    var successfulLogin = false
    var appDelegate: AppDelegate!
    
    @IBAction func signUpButtonClicked() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    @IBAction func loginButtonClicked() {
        setUIEnabled(false)
        getSessionId()
        if (successfulLogin == true) {
            let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
            
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        } else {
            self.warningTextField.hidden = false
        }
        self.setUIEnabled(true)
    }
    
    override func viewDidLoad() {
        self.warningTextField.hidden = true
        
        appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.loginButton.layer.cornerRadius = 5
        self.facebookButton.layer.cornerRadius = 5
        
        //let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.emailTextField.frame.height))
        //emailTextField.leftView = paddingView
        //passwordTextField.leftView = paddingView
        //emailTextField.leftViewMode = UITextFieldViewMode.Always
        //passwordTextField.leftViewMode = UITextFieldViewMode.Always
    }
    
    func getSessionId() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.emailTextField.text!)\", \"password\": \"\(self.passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))

            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON")
                return
            }
            
            if let account = parsedResult["account"] as? [String : AnyObject] {
                if let registered = account["registered"] as? Int {
                    if (registered == 1) {
                        self.successfulLogin = true
                        
                        if let session = parsedResult["session"] as? [String: AnyObject!] {
                            let sessionID = session["id"] as? String
                        }
                        self.appDelegate.sessionID = "sessionID"
                        
                    }
                }
            } else {
                print ("Could not find key account")
            }


        }
        task.resume()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setUIEnabled(enabled: Bool) {
        emailTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        facebookButton.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
}