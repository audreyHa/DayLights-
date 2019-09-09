//
//  SettingsVC.swift
//  DayLights
//
//  Created by Audrey Ha on 8/17/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsVC: UIViewController {

    @IBOutlet weak var enableNotiLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var changeNotiButton: UIButton!
    @IBOutlet var fullView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeLabel.layer.masksToBounds=true
        timeLabel.layer.cornerRadius=5
        
        changeNotiButton.layer.cornerRadius=5
        updateTimeAndSwitch()
        
        enableNotiLabel.adjustsFontSizeToFitWidth=true
        timeLabel.adjustsFontSizeToFitWidth=true
        changeNotiButton.titleLabel?.adjustsFontSizeToFitWidth=true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeAndSwitch), name: NSNotification.Name("updateTimeAndSwitch"), object: nil)

        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "RainDH.jpg")?.draw(in: self.view.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        
        fullView.backgroundColor=UIColor.clear
    }
    
    func makeEnterNotiAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "EnterNotiAlert") as! EnterNotiAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func createNewNotiTime(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        var notiArray=CoreDataHelper.retrieveNotification()
        for noti in notiArray{
            CoreDataHelper.delete(noti: noti)
        }
        makeEnterNotiAlert()
        mySwitch.setOn(true, animated: true)
    }
    
    func makeOKAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "OKAlert") as! OKAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

    @objc func updateTimeAndSwitch(){
        if let settings = UIApplication.shared.currentUserNotificationSettings {
            if settings.types.contains([.alert, .sound]) {
                notiAllowedTimeSwitch()
            } else if settings.types.contains(.alert) {
                notiAllowedTimeSwitch()
            }else{
                timeLabel.text="No Time Set"
                
                if mySwitch.isOn==true{
                    mySwitch.setOn(false, animated: true)
                    UserDefaults.standard.set("settingsTurnOnNoti",forKey: "typeOKAlert")
                    makeOKAlert()
                }
            }
        }
    }
    
    func notiAllowedTimeSwitch(){
        var updatedNotiArray=CoreDataHelper.retrieveNotification()
        if updatedNotiArray.count>0{
            var updateNotificationTime=updatedNotiArray[0]
            var hour=updateNotificationTime.hour
            var minute=updateNotificationTime.minute
            var amPm="AM"
            var minuteZero=false
            
            if hour>12{
                hour-=12
                amPm="PM"
            }else if hour==0{
                hour=12
            }
            
            if minute<10{
                minuteZero=true
            }
            
            if minuteZero{
                timeLabel.text="\(hour):0\(minute):00 \(amPm)"
            }else{
                timeLabel.text="\(hour):\(minute):00 \(amPm)"
            }
            
            mySwitch.setOn(true, animated: false)
        }else{
            timeLabel.text="No Time Set"
            mySwitch.setOn(false, animated: false)
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        if mySwitch.isOn{
            if let settings = UIApplication.shared.currentUserNotificationSettings {
                if settings.types.contains([.alert, .sound]) {
                    createNewNotiTime()
                } else if settings.types.contains(.alert) {
                    createNewNotiTime()
                }else{
                    updateTimeAndSwitch()
                    UserDefaults.standard.set("settingsTurnOnNoti",forKey: "typeOKAlert")
                    makeOKAlert()
                }
                
            }
        }else{
            var notiArray=CoreDataHelper.retrieveNotification()
            for noti in notiArray{
                CoreDataHelper.delete(noti: noti)
            }
            
            updateTimeAndSwitch()
        }
    }
    
    @IBAction func changeNotiTime(_ sender: Any) {
        if let settings = UIApplication.shared.currentUserNotificationSettings {
            if settings.types.contains([.alert, .sound]) {
                createNewNotiTime()
            } else if settings.types.contains(.alert) {
                createNewNotiTime()
            }else{
                updateTimeAndSwitch()
                UserDefaults.standard.set("settingsTurnOnNoti",forKey: "typeOKAlert")
                makeOKAlert()
            }
        }
    }

}
