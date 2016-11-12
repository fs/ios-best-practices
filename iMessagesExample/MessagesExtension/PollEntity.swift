//
//  PollEntity.swift
//  VoteApp
//
//  Created by Ellina Kuznecova on 05.11.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import Foundation
import Messages
import ObjectMapper

struct PollEntity {
    static var entityKey    = "pollEntity"
    static var creatorIdKey = "creatorId"
    static var optionsKey   = "options"
    
    var options: [PollOption]
    var creatorId: String
    
    var queryItems: [URLQueryItem] {
        return [URLQueryItem(name: PollEntity.entityKey, value: self.toJSONString())]
    }
    
    init(creatorId: String) {
        self.creatorId = creatorId
        self.options = []
    }
    
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems)
    }
    
    init?(map: ObjectMapper.Map) {
        self.init(message: nil)
    }
    
    init?(queryItems: [URLQueryItem]) {
        guard let queryItem = queryItems.first,
            let value = queryItem.value,
            queryItem.name == PollEntity.entityKey else { return nil }
        var decodedObject = PollEntity(creatorId: "")
        decodedObject = Mapper<PollEntity>().map(JSONString: value, toObject: decodedObject)
        guard decodedObject.creatorId != "" else {return nil}
        self.creatorId = decodedObject.creatorId
        self.options = decodedObject.options
    }
}

extension PollEntity: Mappable {
    mutating func mapping(map: ObjectMapper.Map) {
        self.creatorId <- map[PollEntity.creatorIdKey]
        self.options <- map[PollEntity.optionsKey]
    }
}

struct PollOption: Mappable {
    var name: String
    var voters: [Voter]
    
    init(name: String) {
        self.name = name
        self.voters = []
    }
    
    init?(map: ObjectMapper.Map) {
        self.init(name: "")
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        self.name <- map["name"]
        self.voters <- map["voters"]
    }
}

struct Voter: Mappable {
    var id: String?
    
    init?(map: ObjectMapper.Map) {}
    
    mutating func mapping(map: ObjectMapper.Map) {
        self.id <- map["id"]
        
    }
}
