//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/21/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    // MARK: Properties
    
    var session = URLSession.shared
    var studentLocation: [StudentLocation] = []
    
    // MARK: Networking methods
    
    func taskForGetManyLocations(method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
    
        // Make the URL request
        let request = NSMutableURLRequest(url: parseURLFromParametersForGET(parameters, withPathExtension: method))
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: JSONParameterKeys.ApplicationID)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: JSONParameterKeys.RestAPIKey)
    
        // Make the task
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
            /* GUARD: Was there an error */
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(error)"]
                completionHandlerForGET(nil, NSError(domain: "taskForGetManyLocations", code: 0, userInfo: userInfo))
                return
            }
        
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForGET(nil, NSError(domain: "taskForGetManyLocations", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForGET(nil, NSError(domain: "taskForGetManyLocations", code: 2, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForGET(nil, NSError(domain: "taskForGetManyLocations", code: 3, userInfo: userInfo))
                }
                return
            }
        
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForGET(nil, NSError(domain: "taskForGetStudentLocation", code: 1, userInfo: userInfo))
                return
            }

            /* Parse the data */        
            self.parseJSONObject(data, completionHandlerForConvertData: completionHandlerForGET)
        
        }
        task.resume()
    }
    
    func taskForGetStudentLocation(method: String, parameters: [String:AnyObject], completionHandlerForGetStudentLocationParse: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        //let urlString = ParseClient.Constants.parseBaseURL + method
        let url = URL(string: ParseClient.Constants.parseBaseURL + method)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(ParseClient.Constants.ParseApplicationID, forHTTPHeaderField: ParseClient.JSONParameterKeys.ApplicationID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.JSONParameterKeys.RestAPIKey)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(error)"]
                completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 0, userInfo: userInfo))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 2, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 3, userInfo: userInfo))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 1, userInfo: userInfo))
                return
            }
            
            /* Parse the data */
            self.parseJSONObject(data, completionHandlerForConvertData: completionHandlerForGetStudentLocationParse)
            
        }
        task.resume()
    }
    
    func taskForPostStudentLocation(method: String, jsonBody: [String:AnyObject], completionHandlerForPOST: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        //let urlString = ParseClient.Constants.parseBaseURL + ParseClient.Methods.Location
        let url = URL(string: ParseClient.Constants.parseBaseURL + ParseClient.Methods.Location)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(ParseClient.Constants.ParseApplicationID, forHTTPHeaderField: ParseClient.JSONParameterKeys.ApplicationID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.JSONParameterKeys.RestAPIKey)
        request.addValue(ParseClient.Constants.ApplicationJSON, forHTTPHeaderField: ParseClient.JSONParameterKeys.ContentType)
        
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            /* GUARD: Was there an error */
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(error)"]
                completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 0, userInfo: userInfo))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 2, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 3, userInfo: userInfo))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 1, userInfo: userInfo))
                return
            }
            
            /* Parse the data */
            self.parseJSONObject(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
    }
    
    func taskForPutStudentLocation(objectId: String, method: String, jsonBody: [String:AnyObject], completionHandlerForPutMethod: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        //let urlString = ParseClient.Constants.parseBaseURL + method + objectId
        let url = URL(string: ParseClient.Constants.parseBaseURL + method + objectId)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(ParseClient.Constants.ParseApplicationID, forHTTPHeaderField: ParseClient.JSONParameterKeys.ApplicationID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.JSONParameterKeys.RestAPIKey)
        request.addValue(ParseClient.Constants.ApplicationJSON, forHTTPHeaderField: ParseClient.JSONParameterKeys.ContentType)
        
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            /* GUARD: Was there an error */
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(error)"]
                completionHandlerForPutMethod(nil, NSError(domain: "taskForPutStudentLocation", code: 0, userInfo: userInfo))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForPutMethod(nil, NSError(domain: "taskForPutStudentLocation", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForPutMethod(nil, NSError(domain: "taskForPutStudentLocation", code: 2, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForPutMethod(nil, NSError(domain: "taskForPutStudentLocation", code: 3, userInfo: userInfo))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForPutMethod(nil, NSError(domain: "taskForPutStudentLocation", code: 1, userInfo: userInfo))
                return
            }
            
            /* Parse the data */
            self.parseJSONObject(data, completionHandlerForConvertData: completionHandlerForPutMethod)
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
    
    private func parseURLFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = "") -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            
            let queryItem = URLQueryItem(name: key, value: "{\"uniqueKey\":\"\(value)\"}") // {"uniqueKey":"1234"}
            components.queryItems!.append(queryItem)
        }

        return components.url!
    }
    
    private func parseURLFromParametersForGET(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
