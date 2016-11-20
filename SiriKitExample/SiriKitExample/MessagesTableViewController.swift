//
//  MessagesTableViewController.swift
//  SiriKitExample
//
//  Created by Ellina Kuznecova on 19.11.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {
    
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contact?.messages.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        cell.textLabel?.text = contact?.messages[indexPath.row].text
        return cell
    }

}
