//
//  ViewController.swift
//  NotificationsExample
//
//  Created by Ellina Kuznecova on 05.12.16.
//  Copyright © 2016 Ellina Kuznecova. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    
    let notificationIdentifiers = ["my_notification1", "my_notification2"]
    let notificationCategoryIdentifier = "notificationCategoryIdentifier"
    let notificationActionIdentifier = "notificationActionIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
            print("alert access: \(granted)")
        })
        UNUserNotificationCenter.current().delegate = self
        self.updateLabel()
        self.configureCategories()
    }
    
    @IBAction func fireNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        content.categoryIdentifier = self.notificationCategoryIdentifier
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier: self.notificationIdentifiers[Int(arc4random()%2)], content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @IBAction func removeNotification() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [self.notificationIdentifiers.first ?? ""])
        self.updateLabel()
    }
    
    func updateLabel() {
        
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { [weak self] (notifications) in
            let resultString = notifications.map({"\($0.request.identifier): \($0.date)"}).reduce("", { $0 + "\n" + $1})
            DispatchQueue.main.async {
                self?.dataLabel.text = resultString
            }
        })
    }
    
    func configureCategories() {
        let action = UNTextInputNotificationAction(identifier: self.notificationActionIdentifier, title: "Action 1", options: [])
        let category = UNNotificationCategory(identifier: self.notificationCategoryIdentifier, actions: [action], intentIdentifiers: [], options: [])
        var categories = Set<UNNotificationCategory>()
        categories.insert(category)
        UNUserNotificationCenter.current().setNotificationCategories(categories)
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        print("willPresent notification")
        self.updateLabel()
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print((response as? UNTextInputNotificationResponse)?.userText ?? "")
        completionHandler()
    }
}

