//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Olivia Murphy on 8/18/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation

extension UdacityClient {

func login(username: String, password: String, completionHandlerForLogin: (result: Bool?, error: NSError?) -> Void) {
    
    taskForLOGINMethod(username, password: password) { (results, error) in
        
        if let error = error {
            completionHandlerForLogin(result: nil, error: error)
        } else {
            if let account = results["account"] as? [String : AnyObject] {
                if let registered = account["registered"] as? Int {
                    if (registered == 1) {
                        self.accountKey = account["key"] as? String

                        if let session = results["session"] as? [String: AnyObject!] {
                            self.sessionID = session["id"] as? String
                        }
                        completionHandlerForLogin(result: true, error: nil)
                    }
                }
            } else {
                completionHandlerForLogin(result: nil, error: NSError(domain: "postToWatchlist parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToWatchlist"]))
            }
        }
    }
}
    
func logout(completionHandlerForLogout: (result: Bool?, error: NSError?) -> Void) {
        
    taskForLOGOUTMethod() { (results, error) in
            
        if let error = error {
            completionHandlerForLogout(result: nil, error: error)
        } else {
            if let session = results["session"] as? [String : AnyObject!] {
                if session["expiration"] as? String != nil {
                    completionHandlerForLogout(result: true, error: nil)
                }
            } else {
                completionHandlerForLogout(result: nil, error: NSError(domain: "postToWatchlist parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToWatchlist"]))
            }
        }
    }
}
    
func getMyUserInfo(completionHandlerForUserInfo: (result: Bool?, error: NSError?) -> Void) {
    taskForUserInfoMethod() { (results, error) in
        
        if let error = error {
            completionHandlerForUserInfo(result: nil, error: error)
        } else {
            if let user = results["user"] as? [String : AnyObject!] {
                UdacityClient.sharedInstance().lastName = String(user["last_name"]!)
                UdacityClient.sharedInstance().firstName = String(user["first_name"]!)
            }
        }
    }
}

}
