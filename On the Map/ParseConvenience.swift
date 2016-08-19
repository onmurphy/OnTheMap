//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Olivia Murphy on 8/18/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import MapKit

extension ParseClient {
    
    func getLocations(completionHandlerForGet: (result: [MKPointAnnotation], error: NSError?) -> Void) {
        
        taskForGETMethod(true) { (results, error) in
            
            var annotations = [MKPointAnnotation]()
            
            if let error = error {
                completionHandlerForGet(result: annotations, error: error)
            } else {
                if let locations = results["results"] as? [[String : AnyObject]] {
                    
                    for dictionary in locations {

                        if dictionary["latitude"] == nil {
                            continue
                        }
                            
                        else if dictionary["longitude"] == nil {
                            continue
                        }
                        
                        let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                        let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                        
                        // The lat and long are used to create a CLLocationCoordinates2D instance.
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let first = dictionary["firstName"] as! String
                        let last = dictionary["lastName"] as! String
                        let name = first + " " + last
                        let mediaURL = dictionary["mediaURL"] as! String
                        
                        let student = ParseStudent(name: name, url: mediaURL)
                        self.students.append(student)
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        // Finally we place the annotation in an array of annotations.
                        annotations.append(annotation)
                    }
                    
                    completionHandlerForGet(result: annotations, error: nil)
                } else {
                    completionHandlerForGet(result: annotations, error: NSError(domain: "postToWatchlist parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToWatchlist"]))
                }
            }
        }
    }
    
    func getMyLocation(completionHandlerForGet: (result: Bool, error: NSError?) -> Void) {
        taskForGETMethod(false) { (result, error) in
            if let error = error {
                completionHandlerForGet(result: false, error: error)
            } else {
                UdacityClient.sharedInstance().firstName = result["firstName"] as? String
                UdacityClient.sharedInstance().lastName = result["lastName"] as? String
                completionHandlerForGet(result: true, error: nil)
            }
        }
    }
    
    func postNewLocation(location: String, url: String, annotation: MKPointAnnotation, completionHandlerForPost: (result: Bool, error: NSError?) -> Void) {
        
        taskForPOSTMethod(location, url: url, annotation: annotation) { (results, error) in
            
            if let error = error {
                completionHandlerForPost(result: false, error: error)
            } else {
                completionHandlerForPost(result: true, error: nil)
            }
        }
    }

}