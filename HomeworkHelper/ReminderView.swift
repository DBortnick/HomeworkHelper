//
//  ReminderView.swift
//  HomeworkHelper
//
//  Created by Dylan Bortnick on 8/17/20.
//  Copyright © 2020 BortnickDev. All rights reserved.
//

import UIKit
import UserNotifications

class ReminderViewController: UIViewController {
    
    var notificationTitle: String? = nil
    var notificationBody: String? = nil
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = notificationTitle
        bodyLabel.text = notificationBody
        enableNotifications()
    }
    
    func enableNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                
            }
            else if error != nil {
                print("Error Occured")
            }
        })
        
    }
    
    
    @IBAction func saveButton() {
        let content = UNMutableNotificationContent()
        content.title = notificationTitle!
        content.sound = .default
        content.body = notificationBody!
    
        let targetDate = datePicker.date
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "id_\(content.title)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil {
            print("some error occured")
            }
        })
    
        _ = navigationController?.popViewController(animated: true)
    }
}
