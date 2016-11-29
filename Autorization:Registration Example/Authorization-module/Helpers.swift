//
//  Helpers.swift
//  Authorization-module
//
//  Created by Kruperfone on 19.11.15.
//  Copyright © 2015 Flatstack. All rights reserved.
//

import Foundation

func ShowOKAlert (message: String, onViewController viewController: UIViewController?) {
    let alertView = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    let alertButton = UIAlertAction(title: "OK", style: .Default) { (alertAction: UIAlertAction) -> Void in
        alertView.dismissViewControllerAnimated(true, completion: nil)
    }
    alertView.addAction(alertButton)
    
    viewController?.presentViewController(alertView, animated: true, completion: nil)
}