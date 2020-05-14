//
//  GameSettingsAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 8/21/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class GameSettingsAlert: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var thirtySec: UIButton!
    @IBOutlet weak var oneMin: UIButton!
    @IBOutlet weak var fiveMin: UIButton!
    
    @IBOutlet weak var easy: UIButton!
    @IBOutlet weak var medium: UIButton!
    @IBOutlet weak var hard: UIButton!
    @IBOutlet weak var extreme: UIButton!
    
    var buttons=[UIButton]()
    var timeButtons=[UIButton]()
    var levelButtons=[UIButton]()
    var mediumBlue: UIColor!
    var lightBlue: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.adjustsFontSizeToFitWidth=true
        yesButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        yesButton.layer.cornerRadius = 5
        yesButton.clipsToBounds = true
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
        
        //set button colors/text width here...
        mediumBlue=UIColor(rgb: 0x1fc2ff)
        lightBlue=UIColor(rgb: 0xe5f9ff)
        buttons=[thirtySec, oneMin, fiveMin, easy, medium, hard, extreme]
        timeButtons=[thirtySec, oneMin, fiveMin]
        levelButtons=[easy, medium, hard, extreme]
        
        for button in buttons{
            button.titleLabel?.adjustsFontSizeToFitWidth=true
            button.layer.cornerRadius=5
        }
        
        highlightTimeButton(timeButton: oneMin)
        highlightLevelButton(levelButton: hard)
        
    }
    
    func highlightTimeButton(timeButton: UIButton){
        timeButton.backgroundColor=mediumBlue
        timeButton.setTitleColor(UIColor.white, for: .normal)
        
        for button in timeButtons{
            if button != timeButton{
                button.backgroundColor=lightBlue
                button.titleLabel?.textColor=UIColor.black
            }
        }
        
        switch(UserDefaults.standard.string(forKey: "gameNumber")){
        case "game1":
            let title=timeButton.titleLabel!.text
            UserDefaults.standard.set(title, forKey: "gameTime")
        case "game2":
            let title=timeButton.titleLabel!.text
            UserDefaults.standard.set(title, forKey: "gameTime2")
        default:
            print("ERROR! I don't recognize this game number")
        }
        
    }
    
    func highlightLevelButton(levelButton: UIButton){
        levelButton.backgroundColor=mediumBlue
        levelButton.setTitleColor(UIColor.white, for: .normal)
        
        for button in levelButtons{
            if button != levelButton{
                button.backgroundColor=lightBlue
                button.titleLabel?.textColor=UIColor.black
            }
        }
        
        switch(UserDefaults.standard.string(forKey: "gameNumber")){
        case "game1":
            let title=levelButton.titleLabel!.text
            UserDefaults.standard.set(title, forKey: "gameLevel")
        case "game2":
            let title=levelButton.titleLabel!.text
            UserDefaults.standard.set(title, forKey: "gameLevel2")
        default:
            print("ERROR! I don't recognize this game number")
        }
        
        
    }
    
    @IBAction func thirtySecPressed(_ sender: Any) {
        highlightTimeButton(timeButton: thirtySec)
    }
    
    @IBAction func oneMinPressed(_ sender: Any) {
        highlightTimeButton(timeButton: oneMin)
    }
    
    @IBAction func fiveMinPressed(_ sender: Any) {
        highlightTimeButton(timeButton: fiveMin)
    }
    
    @IBAction func easyPressed(_ sender: Any) {
        highlightLevelButton(levelButton: easy)
    }
    
    @IBAction func mediumPressed(_ sender: Any) {
        highlightLevelButton(levelButton: medium)
    }
    
    @IBAction func hardPressed(_ sender: Any) {
        highlightLevelButton(levelButton: hard)
    }
    
    @IBAction func extremePressed(_ sender: Any) {
        highlightLevelButton(levelButton: extreme)
    }
    
    @IBAction func okPressed(_ sender: Any) {
        //save values to user defaults
        switch(UserDefaults.standard.string(forKey: "gameNumber")){
        case "game1":
            NotificationCenter.default.post(name: Notification.Name("gameOneInstructions"), object: nil)
        default:
            NotificationCenter.default.post(name: Notification.Name("gameTwoInstructions"), object: nil)
        }
        
        
//        NotificationCenter.default.post(name: Notification.Name("setRandomBalloonGame"), object: nil)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
