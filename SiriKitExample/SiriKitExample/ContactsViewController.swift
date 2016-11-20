//
//  ViewController.swift
//  SiriKitExample
//
//  Created by Ellina Kuznetcova on 18/11/2016.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
    
    let contacts = Contact.createData()
    var selectedContact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let messagesVC = segue.destination as? MessagesTableViewController,
            let lSelectedContact = self.selectedContact else {return}
        messagesVC.contact = lSelectedContact
    }

}

extension ContactsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic")!
        cell.textLabel?.text = contacts?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContact = self.contacts?[indexPath.row]
        self.performSegue(withIdentifier: "toDialog", sender: self)
    }
}

