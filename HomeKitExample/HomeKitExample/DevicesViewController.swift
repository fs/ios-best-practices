//
//  AccessoriesViewController.swift
//  HomeKitExample
//
//  Created by Ellina Kuznecova on 26.11.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import HomeKit

class AccessoriesViewController: UITableViewController {
    struct AccessoryAddSegue {
        static let indentifier = "toAccessoryAdding"
    }
    
    struct DetailAccessorySegue {
        static let indentifier = "toDetailAccessory"
        
        var accessory: HMAccessory
        
        init(accessory: HMAccessory) {
            self.accessory = accessory
        }
    }
    
    var room: HMRoom?
    var accessories: [HMAccessory] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeManager.delegate = self
        
        self.accessories = self.room?.accessories ?? []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        switch identifier {
        case AccessoryAddSegue.indentifier:
            let destNavigationController = segue.destination as? UINavigationController
            (destNavigationController?.topViewController as? AccessorySearcherViewController)?.roomToAdd = self.room
            return
        case DetailAccessorySegue.indentifier:
            guard let segueData = sender as? DetailAccessorySegue else {return}
            (segue.destination as? AccessoryViewController)?.accessory = segueData.accessory
            return
        default:
            return
        }
    }
    
    @IBAction func addPressed(_ sender: Any) {
        self.performSegue(withIdentifier: AccessoryAddSegue.indentifier, sender: nil)
    }
}

extension AccessoriesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accessories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic")!
        cell.textLabel?.text = self.accessories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: DetailAccessorySegue.indentifier, sender: DetailAccessorySegue(accessory: self.accessories[indexPath.row]))
    }
}

extension AccessoriesViewController: HMHomeManagerDelegate {
    
}
