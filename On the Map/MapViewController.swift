//
//  FirstViewController.swift
//  On the Map
//
//  Created by Olivia Murphy on 8/11/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var successfulLogout = false
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func logoutButtonClicked() {
        UdacityClient.sharedInstance().logout() { (successfulLogout, error) in
            if let error = error {
                print(error)

            } else {
                if successfulLogout == true {
                    dispatch_async(dispatch_get_main_queue()) {
                        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudentLocations()
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
            
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    
    func getStudentLocations() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        
        var parsedResult: AnyObject!
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print (error)
            }
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            if let locations = parsedResult["results"] as? [[String : AnyObject]] {
                var annotations = [MKPointAnnotation]()
                
                for dictionary in locations {
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
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
                
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(annotations)
                
            } else {
                print ("could not find key result")
            }
        } catch {
                print ("Could not parse data")
        }
    }
        task.resume()
    }
    
}

