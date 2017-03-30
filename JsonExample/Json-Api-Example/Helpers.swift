//
//  Helpers.swift
//  Json-Api-Example
//
//  Created by Kruperfone on 19.11.15.
//  Copyright © 2015 Flatstack. All rights reserved.
//

import Foundation

enum JADateFormatter {
    static let dayMonthYearDateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
}

func ShowOKAlert (message: String?, onViewController viewController: UIViewController?) {
    let alertView = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    let alertButton = UIAlertAction(title: "OK", style: .default) { (alertAction: UIAlertAction) -> Void in
        alertView.dismiss(animated: true, completion: nil)
    }
    alertView.addAction(alertButton)
    
    viewController?.present(alertView, animated: true, completion: nil)
}
