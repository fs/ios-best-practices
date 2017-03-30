//
//  JASpineManager.swift
//  Timebox
//
//  Created by Никита Асабин on 13.12.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import Spine

class JASpineManager: Spine {
    
    static let shared = JASpineManager()
    
    static let baseURL: URL = {
        
        #if TEST
            return  URL(string: "http://httpbin.org/")!
        #else
            guard let host = Bundle.main.infoDictionary!["URL_HOST"] as? String else { return URL(string: "")!}
            return URL(string:host)!
        #endif
        
    }()
    
    private convenience init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.init(baseURL: JASpineManager.baseURL, networkClient: HTTPClient(session: URLSession(configuration: sessionConfiguration)))
        
//        self.setAuthorizationHeader(token: TBProfileManager.currentUser.token)
//        self.setEmailHeader(email: TBProfileManager.currentUser.email)
    }
    
    func setupSpine() {
        Spine.setLogLevel(.debug, forDomain: .serializing)
        Spine.setLogLevel(.debug, forDomain: .networking)
        JASpineManager.shared.registerResource(JAUserResource.self)
        JASpineManager.shared.registerResource(JAUserResourceForAuthorization.self)
        
    }
    
    func setAuthorizationHeader(token: String?)  {
        guard  let lToken = token else {
            (self.networkClient as! HTTPClient).setHeader("X-User-Token", to: "")
            return
        }
        (self.networkClient as! HTTPClient).setHeader("X-User-Token", to: lToken)
        debugPrint(lToken)
    }
    
    func setEmailHeader(email: String?)  {
        guard  let lEmail = email else {
            (self.networkClient as! HTTPClient).setHeader("X-User-Email", to: "")
            return
        }
        (self.networkClient as! HTTPClient).setHeader("X-User-Email", to: lEmail)
    }
}

class CustomRouter: JSONAPIRouter {
    
    override func queryItemForFilter(on key: String, value: Any?, operatorType: NSComparisonPredicate.Operator) -> URLQueryItem {
        var stringValue = value ?? "null"
        if let valueArray = value as? [String] {
            stringValue = valueArray.joined(separator: ",")
            return URLQueryItem(name: "filter[\(key)]", value: String(describing: stringValue))
        } else {
            return URLQueryItem(name: "filter[\(key)]", value: String(describing: stringValue))
        }
    }
}

class CustomSpineManager: JASpineManager {
    static let sharedWithCustomRouter:CustomSpineManager = {
        let router = CustomRouter()
        router.baseURL = CustomSpineManager.baseURL
        return CustomSpineManager.init(router: router)
    }()
}

