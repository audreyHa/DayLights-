//
//  EnterNotiAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 8/17/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import UserNotifications

class EnterNotiAlert: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yesButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        yesButton.layer.cornerRadius = 5
        yesButton.clipsToBounds = true
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
        headerLabel.adjustsFontSizeToFitWidth=true
        headerLabel.text="When Do You Want Notifications:"

        yesButton.setTitle("OK", for: .normal)
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        
        var strHour = Int32(hourFormatter.string(from: datePicker.date))
        var strMin = Int32(minuteFormatter.string(from: datePicker.date))
        
        var notificationTime=CoreDataHelper.newNotiTime()
        notificationTime.hour=strHour!
        notificationTime.minute=strMin!
        CoreDataHelper.saveDaylight()
        
        // Change the time to 7:00:00 in your locale
        
        var notiArray=CoreDataHelper.retrieveNotification()
        
        if notiArray.count != 0{
            let content=UNMutableNotificationContent()
            content.title="DayHighlights Alert!"
            content.body="Make sure to fill out your DayHighlights for today!"
            content.sound=UNNotificationSound.default
            
            let gregorian = Calendar(identifier: .gregorian)
            let now = Date()
            var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
            
            var updateNotificationTime=notiArray[0]
            components.hour = Int(updateNotificationTime.hour)
            components.minute = Int(updateNotificationTime.minute)
            components.second = 0
            
            let date = gregorian.date(from: components)!
            
            let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
            
            let request=UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
        NotificationCenter.default.post(name: Notification.Name("updateTimeAndSwitch"), object: nil)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
