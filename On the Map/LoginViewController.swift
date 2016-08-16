//
//  LoginViewController.swift
//  On the Map
//
//  Created by Olivia Murphy on 8/13/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUpButtonClicked() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    @IBAction func loginButtonClicked() {
        getSessionId()
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
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MapViewController") as UIViewController
                        self.presentViewController(vc, animated: true, completion: nil)                    }
                }
            } else {
                print ("Could not find key account")
            }


        }
        task.resume()
    }
}