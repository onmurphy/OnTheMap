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
        
        UdacityClient.sharedInstance().login(self.emailTextField.text!, password: self.passwordTextField.text!) { (successfulLogin, error) in
            if let error = error {
                print(error)
                self.warningTextField.hidden = false
            } else {
                if successfulLogin == true {
                    
                    UdacityClient.sharedInstance().getMyUserInfo { (result, error) in
                        if error != nil {
                            self.warningTextField.hidden = false
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
        self.warningTextField.hidden = true
        
        appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.loginButton.layer.cornerRadius = 5
        self.facebookButton.layer.cornerRadius = 5
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
        facebookButton.enabled = enabled

        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
}