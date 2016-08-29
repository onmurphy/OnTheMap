//
//  InfoPostingViewController.swift
//  On the Map
//
//  Created by Olivia Murphy on 8/17/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class InfoPostViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    var appDelegate: AppDelegate!
    var address: String!
    var coordinates : CLLocationCoordinate2D!
    var annotation: MKPointAnnotation!
    
    let geoCoder = CLGeocoder()
    let locationAlertController = UIAlertController(title: "Error", message: "Please enter a valid location.", preferredStyle:
        UIAlertControllerStyle.Alert)
    let linkAlertController = UIAlertController(title: "Error", message: "Please enter a link to be displayed with your pin.", preferredStyle:
        UIAlertControllerStyle.Alert)
    let failureAlertController = UIAlertController(title: "Error", message: "Data could not be posted to server.", preferredStyle:
        UIAlertControllerStyle.Alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) in
        print("OK")
    }
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var questionTextView1: UITextView!
    @IBOutlet weak var questionTextView2: UITextView!
    @IBOutlet weak var questionTextView3: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func cancelButtonClicked() {
        let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
        
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func submitButtonClicked() {
        if self.urlTextField.text == "" {
            self.presentViewController(self.linkAlertController, animated: true, completion: nil)
        } else {
            ParseClient.sharedInstance().postNewLocation(self.locationTextField.text!, url: self.urlTextField.text!, annotation: annotation) { (success, error) in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(self.failureAlertController, animated: true, completion: nil)
                    }
                } else {
                    if success == true {
                        dispatch_async(dispatch_get_main_queue()) {
                            let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
                            
                            self.appDelegate.window?.rootViewController = initialViewController
                            self.appDelegate.window?.makeKeyAndVisible()
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentViewController(self.failureAlertController, animated: true, completion: nil)
                        }
                    }
                }
            }

        }
    }
    
    @IBAction func findButtonClicked() {
        address = locationTextField.text
        
        setUIEnabled(false)
        
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            if error != nil {
                self.presentViewController(self.locationAlertController, animated: true, completion: nil)
            }
            
            if let placemark = placemarks?.first {
                self.coordinates = placemark.location!.coordinate
                
                self.annotation = MKPointAnnotation()
                self.annotation.coordinate = self.coordinates
                self.annotation.title = self.address
                
                self.mapView.addAnnotation(self.annotation)
                
                let span = MKCoordinateSpanMake(0.075, 0.075)
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.coordinates.latitude, longitude: self.coordinates.longitude), span: span)
                self.mapView.setRegion(region, animated: true)
                
                self.findButton.hidden = true
                self.locationTextField.hidden = true
                self.questionTextView1.hidden = true
                self.questionTextView2.hidden = true
                self.questionTextView3.hidden = true
                self.cancelButton.hidden = false
                self.mapView.hidden = false
                self.urlTextField.hidden = false
                self.submitButton.hidden = false
                self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }
        }
        
        setUIEnabled(true)
    }
    
    override func viewDidLoad() {
        appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        self.locationTextField.delegate = self
        self.urlTextField.delegate = self
        
        locationAlertController.addAction(okAction)
        linkAlertController.addAction(okAction)
        failureAlertController.addAction(okAction)
        
        self.mapView.hidden = true
        self.urlTextField.hidden = true
        self.submitButton.hidden = true
        
        self.findButton.layer.cornerRadius = 8
        self.submitButton.layer.cornerRadius = 8
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setUIEnabled(enabled: Bool) {
        cancelButton.enabled = enabled
        locationTextField.enabled = enabled
        findButton.enabled = enabled
        
        if enabled {
            findButton.alpha = 1.0
            cancelButton.alpha = 1.0
        } else {
            findButton.alpha = 0.5
            cancelButton.alpha = 0.5
        }
    }
    
}