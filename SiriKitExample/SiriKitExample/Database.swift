//
//  Person.swift
//  SiriKitExample
//
//  Created by Ellina Kuznecova on 19.11.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

func CustomRealm() -> Realm? {
    let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.ellinakuznecova.SiriKitExample")!
    let realmPath = directory.appendingPathComponent("db.realm")
    
    var config = Realm.Configuration()
    config.fileURL = realmPath
    
    do {
        let realm = try Realm(configuration: config)
        return realm
    }
    catch let error {
        print(error)
        return nil
    }
}

class Contact: Object {
    dynamic var name: String = ""
    var messages = List<Message>()
    
    class func createData() -> Results<Contact>? {
        let realm = CustomRealm()
        if realm?.objects(Contact.self).count == 0 {
            try? realm?.write {
                let messages = List<Message>()
                ["Hey", "How are you?"].forEach({ (value) in
                    let message = Message()
                    message.text = value
                    messages.append(message)
                })
                
                var contacts: [Contact] = []
                ["Jack", "James", "Jessica"].forEach({
                    let contact = Contact()
                    contact.name = $0
                    contact.messages = messages
                    contacts.append(contact)
                })
                realm?.add(contacts)
            }
        }
        return realm?.objects(Contact.self)
    }
}

class Message: Object {
    dynamic var text: String = ""
}
