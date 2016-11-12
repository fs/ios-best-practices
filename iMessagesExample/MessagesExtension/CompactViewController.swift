//
//  CompactViewController.swift
//  VoteApp
//
//  Created by Ellina Kuznecova on 01.11.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import UIKit

protocol CompactViewControllerDelegate: class {
    func createPollPressed()
    func sendMessage()
}

class CompactViewController: UIViewController {
    @IBOutlet weak var actionButton: UIButton!
    
    var options: [PollOption] = []
    weak var delegate: CompactViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let actionButtonTitle = self.options.count > 0 ? "Send Poll" : "Create Poll"
        self.actionButton.setTitle(actionButtonTitle, for: .normal)
    }
    
    @IBAction func actionButtonPressed(_ sender: AnyObject) {
        if self.options.count > 0 {
            self.delegate?.sendMessage()
        } else {
            self.delegate?.createPollPressed()
        }
    }
}
