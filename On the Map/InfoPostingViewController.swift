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
    let geoCoder = CLGeocoder()
    let alertController = UIAlertController(title: "Error", message: "Please enter a valid location.", preferredStyle:
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
    
    @IBAction func findButtonClicked() {
        let address = locationTextField.text
        
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            if error != nil {
                self.presentViewController(self.alertController, animated: true, completion: nil)
            }
            
            if let placemark = placemarks?.first {
                let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                print(coordinates)
                
                var annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = address
                
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
        
        alertController.addAction(okAction)
        
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
    
    // MARK: - MKMapViewDelegate
    
}