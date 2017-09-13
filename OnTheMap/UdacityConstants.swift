//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/10/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
    }
    
    struct Method {
        
        static let SessionURL = "https://www.udacity.com/api/session"
    }
    
    struct UdacityParameterKeys {
        
        static let UdacityDict = [String:AnyObject]()
        static let Username = "username"
        static let Password = "password"
    }
    
    struct UdacityResponseKeys {
        
        static let Session = "session"
        static let SessionID = "id"
        static let Account = "account"
        static let AccountKey = "key"
        
        
    }
    
}