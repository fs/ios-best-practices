//
//  JAToDoViewController.swift
//  Json-Api-Example
//
//  Created by Никита Асабин on 3/30/17.
//  Copyright © 2017 Flatstack. All rights reserved.
//

import UIKit
import Spine
class JAToDoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var toDoResourceCollection: ResourceCollection?
    var toDoArray: [JAToDoResource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
        self.loadToDos()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadToDos(){
        self.activityIndicator.startAnimating()
        JAToDoResource.getToDosForCurrentUser(success: {[weak self] (collection) in
            self?.activityIndicator.stopAnimating()
            guard let lCollection = collection else {return}
            self?.toDoResourceCollection = lCollection
            guard let lTodosArray = lCollection.resources as? [JAToDoResource] else {return}
            self?.toDoArray = lTodosArray
            self?.tableView.reloadData()

        }) { [weak self](error) in
            self?.activityIndicator.stopAnimating()
            ShowOKAlert(message: error?.localizedDescription, onViewController: self)
        }
    }

    @IBAction func createToDo(_ sender: Any) {
    }
}

extension JAToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JAToDoTableViewCell
        cell.configureCellWithTodo(toDo: self.toDoArray[indexPath.row])
        return cell
    }
}
