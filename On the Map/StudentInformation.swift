//
//  StudentInformation.swift
//  On the Map
//
//  Created by Olivia Murphy on 8/28/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation

class StudentInformation {
    var students = [ParseStudent]()
    
    class func sharedInstance() -> StudentInformation {
        struct Singleton {
            static var sharedInstance = StudentInformation()
        }
        return Singleton.sharedInstance
    }
}