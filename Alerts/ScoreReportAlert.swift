//
//  ScoreReportAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 8/28/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class ScoreReportAlert: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    
    var mediumBlue: UIColor!
    
    var recordScore: Int!
    var currentScore: Int!
    var myDayhighlights=CoreDataHelper.retrieveDaylight()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediumBlue=UIColor(rgb: 0x1fc2ff)
        
        startOverButton.titleLabel!.adjustsFontSizeToFitWidth = true
        endButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        startOverButton.layer.cornerRadius = 5
        startOverButton.clipsToBounds = true
        
        endButton.layer.cornerRadius = 5
        endButton.clipsToBounds = true
        
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
        
        headerLabel.adjustsFontSizeToFitWidth=true
        bodyText.adjustsFontSizeToFitWidth=true
        
        var successMessages=["Nice Job!","Keep Trying!","Don't Give Up!","Great Work!"," Good Try!"]
        let randomInt = Int.random(in: 0..<successMessages.count)
        headerLabel.text=successMessages[randomInt]
        
        switch(UserDefaults.standard.string(forKey: "gameNumber")){
        case "game1":
            var gameTime=UserDefaults.standard.string(forKey: "gameTime")
            var gameLevel=UserDefaults.standard.string(forKey: "gameLevel")
            
            switch(gameTime){
            case "30 Sec":
                var record=UserDefaults.standard.integer(forKey: "recordThirty")
                recordScore=record
            case "1 Min":
                var record=UserDefaults.standard.integer(forKey: "recordOneMin")
                recordScore=record
            case "5 Min":
                var record=UserDefaults.standard.integer(forKey: "recordFiveMin")
                recordScore=record
            default:
                print("error in setting min and sec and record values")
            }
            
            currentScore=UserDefaults.standard.integer(forKey: "currentScore")
        case "game2":
            var gameTime=UserDefaults.standard.string(forKey: "gameTime2")
            var gameLevel=UserDefaults.standard.string(forKey: "gameLevel2")
            
            switch(gameTime){
            case "30 Sec":
                var record=UserDefaults.standard.integer(forKey: "recordThirty2")
                recordScore=record
            case "1 Min":
                var record=UserDefaults.standard.integer(forKey: "recordOneMin2")
                recordScore=record
            case "5 Min":
                var record=UserDefaults.standard.integer(forKey: "recordFiveMin2")
                recordScore=record
            default:
                print("error in setting min and sec and record values")
            }
            
            currentScore=UserDefaults.standard.integer(forKey: "currentScore2")
        default:
            print("ERROR! I don't recognize this game number")
        }

        
        if currentScore==recordScore{
            headerLabel.text="NEW RECORD!!"
            bodyText.text="\(currentScore!)"
            bodyText.textColor=mediumBlue
            bodyText.font = bodyText.font.withSize(50)
        }else{
            if recordScore != 0{
                bodyText.text="Current Score: \(currentScore!)\nRecord Score: \(recordScore!)"
                bodyText.textColor=UIColor.black
                bodyText.font = bodyText.font.withSize(22)
            }else{
                headerLabel.text="Hmm... Better Luck Next Time!"
                bodyText.text="Current Score: 0"
                bodyText.textColor=UIColor.black
                bodyText.font = bodyText.font.withSize(22)
            }
            
        }
        
    }
    
    @IBAction func startOverPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("exitScoreReportNewGame"), object: nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
}
