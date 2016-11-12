//
//  ExpandedViewController.swift
//  VoteApp
//
//  Created by Ellina Kuznecova on 01.11.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import UIKit

protocol ExpandedViewControllerDelegate: class {
    func pollUpdated(poll: PollEntity)
}

class ExpandedViewController: UIViewController {
    @IBOutlet weak var pollVariantTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewVariant: UIButton!
    
    weak var delegate: ExpandedViewControllerDelegate?
    var data: PollEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.changeViewsState(to: self.data.options.count == 0)
    }
    
    @IBAction func addNewVariantPressed(_ sender: AnyObject) {
        self.changeViewsState(to: true)
    }
    
    @IBAction func savePressed(_ sender: AnyObject) {
        guard let text = self.pollVariantTextField.text, text != "" else {return}
        self.data.options.append(PollOption(name: text))
        self.pollVariantTextField.text = ""
        self.tableView.reloadData()
        self.delegate?.pollUpdated(poll: self.data)
        self.changeViewsState(to: false)
    }
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        self.changeViewsState(to: false)
    }
    
    private func changeViewsState(to visibility: Bool) {
        self.tableView.isHidden = visibility
        self.addNewVariant.isHidden = visibility
    }
}

extension ExpandedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic")!
        cell.textLabel?.text = self.data.options[indexPath.row].name
        return cell
    }
}

extension ExpandedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.savePressed(self)
        return true
    }
}
