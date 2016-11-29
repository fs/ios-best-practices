//
//  AuthorizationAPIExtension.swift
//  Authorization-module
//
//  Created by Nikita Asabin on 14.06.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class AuthorizationAPIManager:APIManager {
  
    class var defaultAuthorization: AuthorizationAPIManager {
        struct Static {
            static var instance: AuthorizationAPIManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = AuthorizationAPIManager()
        }
        
        return Static.instance!
    }
    
    func signUpWithProvider(provider: String, token: String, success:APIManagerSuccessBlock?, failure:APIManagerFailureBlock?) {
        let params = ["token":token, "provider":provider]
        self.manager.API_POST("oauth_sessions", params: params, success: { (task, response) in
            success?(task: task, response: response)
            }, failure:  { (task, error) in
                failure?(task: task, error: error)
        })
    }
    
    func signUpWithEmail(params:Dictionary<String, AnyObject>, success:APIManagerSuccessBlock?, failure:APIManagerFailureBlock?) {
  
        self.manager.API_POST("users/sign_up", params: params, success: { (task, response) in
              success?(task: task, response: response)
            }, failure:  { (task, error) in
              failure?(task: task, error: error)
        })
    }
    
    func signInWithEmail(email: String, password: String, success:APIManagerSuccessBlock?, failure:APIManagerFailureBlock?) {
        let params = ["email":email, "password":password]
        self.manager.API_POST("users/sign_in", params: params, success: { (task, response) in
            success?(task: task, response: response)
            }, failure:  { (task, error) in
                failure?(task: task, error: error)
        })
    }
    func resetPassword(email: String, success:APIManagerSuccessBlock?, failure:APIManagerFailureBlock?) {
        let params = ["email":email]
        self.manager.API_POST("users/password", params: params, success: { (task, response) in
            success?(task: task, response: response)
            }, failure:  { (task, error) in
                failure?(task: task, error: error)
        })
    }

    
    
}
