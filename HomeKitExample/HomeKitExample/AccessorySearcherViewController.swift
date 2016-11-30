//
//  AccessorySearcherViewController.swift
//  HomeKitExample
//
//  Created by Ellina Kuznecova on 27.11.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import HomeKit

class AccessorySearcherViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    var accessoryBrowser: HMAccessoryBrowser?
    var roomToAdd: HMRoom!
    var availableAccessories: [HMAccessory] = [] {
        didSet {
            self.tableview.reloadData()
            self.tableview.isHidden = availableAccessories.count == 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.isHidden = true
        
        self.accessoryBrowser = HMAccessoryBrowser()
        self.accessoryBrowser?.delegate = self
        self.accessoryBrowser?.startSearchingForNewAccessories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.accessoryBrowser?.stopSearchingForNewAccessories()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AccessorySearcherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableAccessories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic")!
        cell.textLabel?.text = self.availableAccessories[indexPath.row].name
        return cell
    }
}

extension AccessorySearcherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAccessory = self.availableAccessories[indexPath.row]
        HomeManager.primaryHome?.addAccessory(selectedAccessory, completionHandler: {[weak self] (error) in
            guard error == nil else {print(error!); return}
            guard let roomToAdd = self?.roomToAdd else {return}
            HomeManager.primaryHome?.assignAccessory(selectedAccessory, to: roomToAdd, completionHandler: { (error) in
                guard error == nil else {print(error!); return}
                self?.dismiss(animated: true, completion: nil)
            })
        })
    }
}

extension AccessorySearcherViewController: HMAccessoryBrowserDelegate {
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        self.availableAccessories.append(accessory)
    }
}
