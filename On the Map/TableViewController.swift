//
//  SecondViewController.swift
//  On the Map
//
//  Created by Olivia Murphy on 8/11/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    var successfulLogout = false
    
    @IBOutlet weak var tableView: UITableView!
    
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
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
    extension TableViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            /* Get cell type */
            let cellReuseIdentifier = "TableViewCell"
            let student = StudentInformation.sharedInstance().students[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
            
            /* Set cell defaults */
            cell.textLabel!.text = student.name
            print(student.name)
            
            return cell
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return StudentInformation.sharedInstance().students.count
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let app = UIApplication.sharedApplication()
            
            let student = StudentInformation.sharedInstance().students[indexPath.row]
            
            app.openURL(NSURL(string: student.url)!)
        }
    }


