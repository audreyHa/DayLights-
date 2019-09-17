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
        case "todayStressGames":
            headerLabel.text="ALERT!"
            bodyText.text="Looks like your stress was not great today! Let's play some stress games!"
            yesButton.setTitle("LET'S GO!", for: .normal)
            
        case "stressGames":
            headerLabel.text="ALERT!"
            bodyText.text="Looks like your stress has not been great for the past few days... Let's play some stress games!"
            yesButton.setTitle("LET'S GO!", for: .normal)
            
        case "weekTalkToFriend":
            headerLabel.text="ALERT!"
            bodyText.text="Looks like you stress has not been great for the past week... Let's look at your stress crisis kit!"
            yesButton.setTitle("LET'S GO!", for: .normal)
        
        case "weeksTalkToFriend":
            headerLabel.text="ALERT!"
            bodyText.text="Looks like your stress has not been good for the past few weeks... Let's look at your stress crisis kit!"
            yesButton.setTitle("LET'S GO!", for: .normal)
            
        case "noMoodData":
            headerLabel.text="ALERT!"
            bodyText.text="You do not have enough stress data yet!\n\nCheck back after filling out at least 2 entries!"
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
        case "gameOneInstructions":
            headerLabel.text="Instructions!"
            bodyText.text="Pop each balloon as they appear!"
            yesButton.setTitle("OK", for: .normal)
        case "gameTwoInstructions":
            headerLabel.text="Instructions!"
            bodyText.text="Drag the angry balloons down and the happy balloons up!"
            yesButton.setTitle("OK", for: .normal)
        case "enterDHText":
            headerLabel.text="Incomplete!"
            bodyText.text="Please fill out the text fields before saving!"
            yesButton.setTitle("OK", for: .normal)
        case "enterAllDH":
            headerLabel.text="Incomplete!"
            bodyText.text="Please fill out the text fields and stress level before saving!"
            yesButton.setTitle("OK", for: .normal)
        case "contactsNoAccess":
            headerLabel.text="Alert!"
            bodyText.text="DayHighlights can not add your contacts since you did not give the app access to them. You can go into settings and change this."
            yesButton.setTitle("OK", for: .normal)
        case "photosNoAccess":
            headerLabel.text="Alert!"
            bodyText.text="DayHighlights can not screenshot your drawing and add it to your Photos since you did not give the app access to your Photos Library. You can go into settings and change this."
            yesButton.setTitle("OK", for: .normal)
        case "successfulScreenshot":
            headerLabel.text="Nice!"
            bodyText.text="Your current drawing is screenshotted and saved to your Photos Library!"
            yesButton.setTitle("OK", for: .normal)
        default:
            print("Error! Could not react to yes no alert!")
        }
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        switch (UserDefaults.standard.string(forKey: "typeOKAlert")) {
        case "todayStressGames":
            NotificationCenter.default.post(name: Notification.Name("stressGames"), object: nil)
            
        case "stressGames":
            NotificationCenter.default.post(name: Notification.Name("stressGames"), object: nil)
            
        case "weekTalkToFriend":
            NotificationCenter.default.post(name: Notification.Name("stressCrisis"), object: nil)
            
        case "weeksTalkToFriend":
            NotificationCenter.default.post(name: Notification.Name("stressCrisis"), object: nil)

        case "settingsTurnOnNoti":
            NotificationCenter.default.post(name: Notification.Name("updateTimeAndSwitch"), object: nil)
            
        case "gameOneInstructions":
            NotificationCenter.default.post(name: Notification.Name("setRandomBalloonGame"), object: nil)
            
        case "gameTwoInstructions":
            NotificationCenter.default.post(name: Notification.Name("setSecondBalloonGame"), object: nil)
        
        default:
            print("default yes")
        }
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
