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
    
    let failureAlertController = UIAlertController(title: "Error", message: "Pins could not be loaded. Check your network connection and try again.", preferredStyle:
        UIAlertControllerStyle.Alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) in
        print("OK")
    }
    
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
    
    @IBAction func refreshButtonClicked() {
        loadPins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        failureAlertController.addAction(okAction)
        loadPins()
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
    
    private func loadPins() {
        ParseClient.sharedInstance().getLocations() { (annotations, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(self.failureAlertController, animated: true, completion: nil)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(annotations)
                }
            }
        }
    }
}

