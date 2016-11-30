//
//  AccessoryViewController.swift
//  HomeKitExample
//
//  Created by Ellina Kuznecova on 27.11.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import HomeKit

class AccessoryViewController: UIViewController {
    @IBOutlet weak var onOffSwitch: UISwitch!
    @IBOutlet weak var accessoryTitle: UILabel!
    
    var accessory: HMAccessory?
    var onOffCharacterictic: HMCharacteristic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onOffCharacterictic = self.accessory?.services.last?.characteristics.filter({$0.characteristicType == HMCharacteristicTypePowerState}).first
        self.accessoryTitle.text = accessory?.name
        
        let onOffCharactericticState = self.onOffCharacterictic?.value as? Bool ?? false
        self.onOffSwitch.setOn(onOffCharactericticState, animated: true)
    }
    
    
    @IBAction func switchValueChanged(_ sender: Any) {
        self.onOffCharacterictic?.writeValue(self.onOffSwitch.isOn, completionHandler: { (error) in
            if let error = error {print(error)}
        })
    }
}
