//
//  ParseStudent.swift
//  On the Map
//
//  Created by Olivia Murphy on 8/19/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

struct ParseStudent {
    
    let name: String
    let url: String
    let location: String
    
    init(student: [String: String]) {
        self.name = student["name"]!
        self.url = student["url"]!
        self.location = student["location"]!
    }
}
