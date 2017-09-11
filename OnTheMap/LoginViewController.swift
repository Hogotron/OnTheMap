//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/10/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Functions
    @IBAction func loginPressed(_ sender: AnyObject) {
        getSessionID()
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    func getSessionID() {
    
        // Set the parameters
        let parameters = [String:AnyObject]()
        
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"udacity\": {\"username\": \"\(usernameTextField.text)\", \"password\": \"\(passwordTextField.text)\"}}".data(using: String.Encoding.utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
        // if an error occurs, print it and re-enable the UI
        func displayError(_ error: String, debugLabelText: String? = nil) {
            print(error)
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                //self.debugTextLabel.text = "Login Failed (Login Step)."
            }
        }
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            displayError("There was an error with your request: \(error!)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            displayError("Your request returned a status code other than 2xx!")
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            displayError("No data was returned by the request!")
            return
        }
        
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range) /* subset response data! */
        print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
        
        /* 5. Parse the data */
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            print("Could not parse the data as JSON: '\(data)'")
            return
        }
        
        /* GUARD: Is the "id" key in parsedResult? */
        guard let sessionID = parsedResult![UdacityClient.UdacityResponseKeys.SessionID] as? Int else {
            displayError("Cannot find key '\(UdacityClient.UdacityResponseKeys.SessionID)' in \(parsedResult)")
            return
        }
        
        /* 6. Use the data! */
        print(sessionID)
        }
        
        task.resume()
    }

    deinit {
        print("The LoginViewController was deinitialized")
    }
    
}

extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
    }
}
