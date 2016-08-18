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
        
        taskForGETMethod() { (results, error) in
            
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
                        let mediaURL = dictionary["mediaURL"] as! String
                        
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
}