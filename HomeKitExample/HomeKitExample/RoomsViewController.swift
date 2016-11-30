//
//  RoomsViewController.swift
//  HomeKitExample
//
//  Created by Ellina Kuznetcova on 12.07.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import HomeKit

class RoomsViewController: UITableViewController {
    
    struct AccessoriesSegue {
        static let identifier = "toAccessories"
        
        var selectedRoom: HMRoom
        
        init(selectedRoom: HMRoom) {
            self.selectedRoom = selectedRoom
        }
    }
    
    var rooms : [HMRoom] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeManager.delegate = self
        
        FSDispatch_after_short(1.0, block: {[weak self] in
            self?.rooms = HomeManager.primaryHome?.rooms ?? []
        })
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Choose an object to cteate", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Home", style: .default, handler: { [weak self] (action) in
            let homeAlertController = UIAlertController(title: "Enter home name", message: nil, preferredStyle: .alert)
            homeAlertController.addTextField(configurationHandler: nil)
            homeAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak homeAlertController] (alertAction) in
                guard let homeName = homeAlertController?.textFields?.first?.text else {return}
                HomeManager.addHome(withName: homeName, completionHandler: { (home, error) in
                    guard let error = error else {return}
                    print(error)
                })
            }))
            self?.showDetailViewController(homeAlertController, sender: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Room", style: .default, handler: { [weak self] (action) in
            let roomAlertController = UIAlertController(title: "Enter room name", message: nil, preferredStyle: .alert)
            roomAlertController.addTextField(configurationHandler: nil)
            roomAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak roomAlertController] (alertAction) in
                guard let roomName = roomAlertController?.textFields?.first?.text else {return}
                HomeManager.primaryHome?.addRoom(withName: roomName, completionHandler: { (room, error) in
                    guard let lRoom = room, error == nil else {print(error!); return}
                    self?.rooms.append(lRoom)
                })
            }))
            self?.showDetailViewController(roomAlertController, sender: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.showDetailViewController(alertController, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let accessoriesSegue = sender as? AccessoriesSegue else {return}
        (segue.destination as? AccessoriesViewController)?.room = accessoriesSegue.selectedRoom
    }
}

extension RoomsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic")!
        cell.textLabel?.text = self.rooms[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: AccessoriesSegue.identifier, sender: AccessoriesSegue(selectedRoom: self.rooms[indexPath.row]))
    }
}

extension RoomsViewController: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
//        self.rooms = manager.homes
//        print(self.homes)
//        print(self.homes[0].rooms)
    }
}

