//
//  UdacityClient2.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/12/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    
    var session = URLSession.shared
    
    var accountKey: String? = ""
    var sessionID: String? = ""
    
    
    func taskForPOSTSession(email:String, password:String, completionHandlerForPostSession: @escaping (_ data:AnyObject?, _ error: NSError?) -> Void) {
    
        // Make the request
        let request = NSMutableURLRequest(url: URL(string: UdacityClient.Constants.UdacityBaseURL + UdacityClient.Method.Session)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let httpBodyString = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        request.httpBody = httpBodyString.data(using: String.Encoding.utf8)
        
        // Create the task
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(error)"]
                completionHandlerForPostSession(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForPostSession(nil, NSError(domain: "taskForPostSession", code: 0, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForPostSession(nil, NSError(domain: "taskForPostSession", code: 1, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForPostSession(nil, NSError(domain: "taskForPostSession", code: 2, userInfo: userInfo))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForPostSession(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
                return
            }
            
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            //print("This is the taskForPostSessionData: \n \(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!) \n")
            
            /* 5. Parse the data */
            
            self.parseJSONObject(newData, completionHandlerForConvertData: completionHandlerForPostSession)
            
            })
        task.resume()
    }
    
    func taskForGETPublicUserData(method: String, uniqueKey: String, completionHandlerForGetPublicUserData: @escaping (_ data: AnyObject?, _ error: NSError?) -> Void) {
        
        // Make the request
        let request = NSMutableURLRequest(url: URL(string: Constants.UdacityBaseURL + method + uniqueKey)!)
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(error)"]
                completionHandlerForGetPublicUserData(nil, NSError(domain: "taskForGETPublicUserData", code: 1, userInfo: userInfo))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForGetPublicUserData(nil, NSError(domain: "taskForGETPublicUserData", code: 0, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForGetPublicUserData(nil, NSError(domain: "taskForGETPublicUserData", code: 1, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForGetPublicUserData(nil, NSError(domain: "taskForGETPublicUserData", code: 2, userInfo: userInfo))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForGetPublicUserData(nil, NSError(domain: "taskForGETPublicUserData", code: 1, userInfo: userInfo))
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            //print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            self.parseJSONObject(newData, completionHandlerForConvertData: completionHandlerForGetPublicUserData)
            
        }
        
        task.resume()
    }
    
    func parseJSONObject(_ data: Data, completionHandlerForConvertData: (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(nil, NSError(domain: "parseJSONObject", code: 0, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }

    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    deinit {
        print("The LoginViewController was deinitialized")
    }
}
