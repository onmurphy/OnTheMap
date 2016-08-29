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
    @IBOutlet weak var loginButton: UIButton!
    
    var successfulLogin = false
    var appDelegate: AppDelegate!
    
    let failureAlertController = UIAlertController(title: "Error", message: "Data could not be posted to server. Check your network connection and try again.", preferredStyle:
        UIAlertControllerStyle.Alert)
    let incorrectAlertController = UIAlertController(title: "Error", message: "Incorrect username or password.", preferredStyle:
        UIAlertControllerStyle.Alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) in
        print("OK")
    }
    
    @IBAction func signUpButtonClicked() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    @IBAction func loginButtonClicked() {
        setUIEnabled(false)
        
        UdacityClient.sharedInstance().login(self.emailTextField.text!, password: self.passwordTextField.text!) { (successfulLogin, error) in
            if let error = error {
                if error == "403" {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(self.incorrectAlertController, animated: true, completion: nil)
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(self.failureAlertController, animated: true, completion: nil)
                    }
                }
            } else {
                if successfulLogin == true {
                    
                    UdacityClient.sharedInstance().getMyUserInfo { (result, error) in
                        if error != nil {
                            print(error)
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
                        
                        self.appDelegate.window?.rootViewController = initialViewController
                        self.appDelegate.window?.makeKeyAndVisible()
                    }
                }
            }
            self.setUIEnabled(true)
        }
    }
    
    override func viewDidLoad() {
        
        appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        failureAlertController.addAction(okAction)
        incorrectAlertController.addAction(okAction)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func moveToTabView() {
        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
        
        self.appDelegate.window?.rootViewController = initialViewController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    private func setUIEnabled(enabled: Bool) {
        emailTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled

        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
}