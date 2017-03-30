//
//  JAUserResource.swift
//  Json-Api-Example
//
//  Created by Никита Асабин on 3/24/17.
//  Copyright © 2017 Flatstack. All rights reserved.
//

import UIKit
import Spine

class JAUserResource: Resource {
    var email: String?
    var password: String?
    
    override class var resourceType:ResourceType {
        return "users"
    }
    
    override class var fields:[Field] {
        return fieldsFromDictionary([
           "email" : Attribute(),
           "password" : Attribute()])
    }
    
}

extension JAUserResource {
    func registerUser(completed: @escaping (Resource?) -> Void) {
        JASpineManager.shared.save(self)
            .onSuccess { (collection) in
                completed(collection as? Resource)
        }
        .onFailure { (error) in
            completed(nil)
        }
    }
}


class  JAUserResourceForAuthorization:JAUserResource  {
    var authentication_token: String?
    
    override class var resourceType:ResourceType {
        return "sessions"
    }
    override class var fields:[Field] {
        return fieldsFromDictionary([
            "email" : Attribute(),
            "password" : Attribute(),
            "authentication_token" : Attribute().serializeAs("authentication-token")
            ])
    }
}

extension JAUserResourceForAuthorization {
    func loginUser(completed: @escaping (JAUserResourceForAuthorization?) -> Void) {
    
        JASpineManager.shared.save(self)
            .onSuccess { (collection) in
                completed(collection as? JAUserResourceForAuthorization)
            }
            .onFailure { (error) in
                completed(nil)
        }
    }
}
