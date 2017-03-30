//
//  JAToDoResource.swift
//  Json-Api-Example
//
//  Created by Никита Асабин on 3/24/17.
//  Copyright © 2017 Flatstack. All rights reserved.
//

import UIKit
import Spine

class JAToDoResource: Resource {
    var title: String?
    var text: String?
    var createdAt: Date?
    var updatedAt: Date?
    var status: String?
    
    
    override class var resourceType:ResourceType {
        return "todo-items"
    }
    
    override class var fields:[Field] {
        return fieldsFromDictionary([
            "title" : Attribute(),
            "text" : Attribute(),
            "createdAt" : DateAttribute().serializeAs("created-at"),
            "updatedAt" : DateAttribute().serializeAs("updated-at"),
            "status" : Attribute()])
    }
}

extension JAToDoResource {
    static func getToDosForCurrentUser(success: @escaping (ResourceCollection?)-> Void, failure: @escaping (SpineError?)-> Void) {
       
        JASpineManager.shared.findAll(JAToDoResource.self)
            .onSuccess { (resources, meta, jsonapi) in
                success(resources)
        }
        .onFailure { (error) in
            failure(error)
        }
    }
}
