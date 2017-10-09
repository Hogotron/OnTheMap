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
    
    // MARK: Outlets
    
    @IBOutlet var studentLocationsTableView: UITableView!
    

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                performUIUpdatesOnMain {
                    self.studentLocationsTableView.reloadData()
                }
            } else {
                print(error ?? "empty error")
            }
        }
    }

    
    deinit {
        print("The TableViewController was deinitialized")
    }
    
    @IBAction func refreshLocations(_ sender: Any) {
        
        print("Is this shit being called???")
        ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                performUIUpdatesOnMain {
                    self.studentLocationsTableView.reloadData()
                    print("Data is being reloaded")
                }
            } else {
                print(error ?? "empty error")
            }
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
    
    @IBAction func addLocationPressed(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
