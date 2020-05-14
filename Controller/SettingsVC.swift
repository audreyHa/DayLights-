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
    @IBOutlet weak var linksTextView: UITextView!
    
    @IBOutlet weak var purple1: UIImageView!
    @IBOutlet weak var purple2: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.adjustsFontSizeToFitWidth=true
        
        timeLabel.layer.masksToBounds=true
        timeLabel.layer.cornerRadius=5
        
        purple1.layer.cornerRadius=15
        purple2.layer.cornerRadius=15
        
        self.purple1.layer.masksToBounds = true
        self.purple2.layer.masksToBounds = true
        changeNotiButton.layer.cornerRadius=changeNotiButton.frame.height/2
        
        updateTimeAndSwitch()
        
        enableNotiLabel.adjustsFontSizeToFitWidth=true
        timeLabel.adjustsFontSizeToFitWidth=true
        changeNotiButton.titleLabel?.adjustsFontSizeToFitWidth=true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeAndSwitch), name: NSNotification.Name("updateTimeAndSwitch"), object: nil)

        linksTextView.text="Alamofire\n\nSwifty JSON\n\niOS Charts\n\nQuotable"
        
        let linkedText = NSMutableAttributedString(attributedString: linksTextView.attributedText)
        
        //Alamofire
        let hyperlinkedAlamofire = linkedText.setAsLink(textToFind: "Alamofire", linkURL: "https://github.com/Alamofire/Alamofire")
        
        if hyperlinkedAlamofire {
            linksTextView.attributedText = NSAttributedString(attributedString: linkedText)
        }
        
        //Swifty JSON
        let hyperlinkedSwiftyJSON = linkedText.setAsLink(textToFind: "Swifty JSON", linkURL: "https://github.com/SwiftyJSON/SwiftyJSON")
        
        if hyperlinkedSwiftyJSON {
            linksTextView.attributedText = NSAttributedString(attributedString: linkedText)
        }
        
        //Charts
        let hyperlinkedCharts = linkedText.setAsLink(textToFind: "iOS Charts", linkURL: "https://github.com/danielgindi/Charts")
        
        if hyperlinkedCharts {
            linksTextView.attributedText = NSAttributedString(attributedString: linkedText)
        }
        
        //Quotable
        let hyperlinkedQuotes = linkedText.setAsLink(textToFind: "Quotable", linkURL: "https://github.com/lukePeavey/quotable#examples")
        
        if hyperlinkedQuotes {
            linksTextView.attributedText = NSAttributedString(attributedString: linkedText)
        }

        linksTextView.layer.cornerRadius=5
    }
    
    @IBAction func xPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
            self.addAttribute(.link, value: linkURL, range: foundRange)
            
            let multipleAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            
            self.addAttributes(multipleAttributes, range: foundRange)
            
            return true
        }
        return false
    }
}
