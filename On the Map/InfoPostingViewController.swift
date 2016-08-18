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
    
    let geoCoder = CLGeocoder()
    let locationAlertController = UIAlertController(title: "Error", message: "Please enter a valid location.", preferredStyle:
        UIAlertControllerStyle.Alert)
    let linkAlertController = UIAlertController(title: "Error", message: "Please enter a link to be displayed with your pin.", preferredStyle:
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
            postNewLocation()
        }
    }
    
    @IBAction func findButtonClicked() {
        address = locationTextField.text
        
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            if error != nil {
                self.presentViewController(self.locationAlertController, animated: true, completion: nil)
            }
            
            if let placemark = placemarks?.first {
                self.coordinates = placemark.location!.coordinate
                print(self.coordinates)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = self.coordinates
                annotation.title = self.address
                
                self.mapView.addAnnotation(annotation)
                
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
    }
    
    override func viewDidLoad() {
        appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        self.locationTextField.delegate = self
        
        locationAlertController.addAction(okAction)
        linkAlertController.addAction(okAction)
        
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
    
    func postNewLocation() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(self.locationTextField.text)\", \"mediaURL\": \"\(self.urlTextField.text)\",\"latitude\": \(self.coordinates.latitude), \"longitude\": \(self.coordinates.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    // MARK: - MKMapViewDelegate
    
}