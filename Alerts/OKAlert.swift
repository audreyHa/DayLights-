//
//  OKAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 8/17/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class OKAlert: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var yesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.adjustsFontSizeToFitWidth=true
        bodyText.adjustsFontSizeToFitWidth=true
        yesButton.titleLabel!.adjustsFontSizeToFitWidth = true

        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        yesButton.layer.cornerRadius = 5
        yesButton.clipsToBounds = true
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
        
        switch (UserDefaults.standard.string(forKey: "typeOKAlert")) {
        case "resources":
            headerLabel.text="ALERT!"
            bodyText.text="Looks like your mood has not been good for the past few weeks... Let's look at some resources!"
            yesButton.setTitle("LET'S GO!", for: .normal)
        case "weekTalkToFriend":
            headerLabel.text="ALERT!"
            bodyText.text="Looks like you mood has not been great for the past week... Please make sure to talk to a family member or guardian, trusted adult, teacher, or friend."
            yesButton.setTitle("I WILL talk to someone!", for: .normal)
        case "daysTalkToFriend":
            headerLabel.text="ALERT!"
            bodyText.text="Looks like your mood has not been great for the past few days... Try talking to a family member or guardian, trusted adult, teacher, or friend!"
            yesButton.setTitle("I WILL talk to someone!", for: .normal)
        case "noMoodData":
            headerLabel.text="ALERT!"
            bodyText.text="You do not have any mood data yet!\n\nCheck back after filling out at least 2 entries!"
            yesButton.setTitle("OK", for: .normal)
        case "noDaylightData":
            headerLabel.text="ALERT!"
            bodyText.text="You do not have any DayHighlights yet!\n\nCheck back after filling out an entry!"
            yesButton.setTitle("OK", for: .normal)
        case "noDaylightToday":
            headerLabel.text="ALERT!"
            bodyText.text="You did not make DayHighlights on this day!"
            yesButton.setTitle("OK", for: .normal)
        case "settingsTurnOnNoti":
            headerLabel.text="ALERT!"
            bodyText.text="First you need to go to settings, scroll down to the DayHighlights App, and allow notifications!"
            yesButton.setTitle("OK", for: .normal)
        default:
            print("Error! Could not react to yes no alert!")
        }
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        switch (UserDefaults.standard.string(forKey: "typeOKAlert")) {
        case "resources":
            NotificationCenter.default.post(name: Notification.Name("segueResources"), object: nil)
            
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        case "settingsTurnOnNoti":
            NotificationCenter.default.post(name: Notification.Name("updateTimeAndSwitch"), object: nil)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        default:
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}
