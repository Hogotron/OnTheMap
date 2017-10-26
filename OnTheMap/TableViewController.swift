//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/8/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    
    // MARK: Properties
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: Outlets
    
    @IBOutlet var studentLocationsTableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AlertView.startActivityIndicator(studentLocationsTableView, activityIndicator: self.activityIndicator)
        
        ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
            
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                
                performUIUpdatesOnMain {
                    self.studentLocationsTableView.reloadData()
                    AlertView.stopActivityController(self.studentLocationsTableView, activityIndicator: self.activityIndicator)
                }
            } else {
                AlertView.showAlert(view: self, message: "Couldn't load student locations")
            }
        }
    }

    @IBAction func refreshLocations(_ sender: Any) {

        AlertView.startActivityIndicator(self.view, activityIndicator: self.activityIndicator)
        
        ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
            
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                
                performUIUpdatesOnMain {
                    self.studentLocationsTableView.reloadData()
                    AlertView.stopActivityController(self.view, activityIndicator: self.activityIndicator)
                }
            } else {
                AlertView.showAlert(view: self, message: "Couldn't load student locations")
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        UdacityClient.sharedInstance().taskForDeleteSession(session: UdacityClient.sharedInstance().sessionID!) { (data, error) in
            
            performUIUpdatesOnMain {
                
                if (data != nil) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    AlertView.showAlert(view: self, message: "Couldn't delete session")
                }
            }
        }
    }
    
    @IBAction func addLocationPressed(_ sender: Any) {
  
        if User.shared.objectId != "" {
            
            let alert = UIAlertController(title: "Overwrite location?", message: "Your student location already exists, do you want to overwrite it?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationNavigationViewController") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            performUIUpdatesOnMain {
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationNavigationViewController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocation") as! TableViewCell
        let studentLocation = studentLocations[indexPath.row]
        
        cell.textLabel!.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel!.text = "\(studentLocation.mediaURL)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let studentLocation = studentLocations[indexPath.row]
        
        let app = UIApplication.shared
        app.open(URL(string: studentLocation.mediaURL)!, options: [:], completionHandler: nil)
        
    }
    
}
