//
//  RandomBalloonsVC.swift
//  DayLights
//
//  Created by Audrey Ha on 8/21/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AudioToolbox
import Firebase

class RandomBalloonsVC: UIViewController {

    var balloonTimer = Timer()
    @IBOutlet weak var gameView: UIView!

    @IBOutlet weak var instructionsLabel: UILabel!
    
    var secondInterval: Double!
    var totalMin: Int!
    var totalSec: Int!
    var recordValue: Int!
    var increasingValue=0
    
    var gameTimer=Timer()
    var mediumBlue: UIColor!
    
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countdownTimer: UILabel!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var easy: UIButton!
    @IBOutlet weak var medium: UIButton!
    @IBOutlet weak var hard: UIButton!
    @IBOutlet weak var extreme: UIButton!
    
    var myButtons=[UIButton]()
    var originalButtonColors=[UIColor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameView.layer.cornerRadius=10
        
        myButtons=[easy, medium, hard, extreme]
        originalButtonColors=[UIColor(rgb: 0xDBF3FC), UIColor(rgb: 0x95B1E8), UIColor(rgb: 0xFFFFFF), UIColor(rgb: 0xCDA3FF)]

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        instructionsLabel.adjustsFontSizeToFitWidth=true

        mediumBlue=UIColor(rgb: 0x1fc2ff)
        
        startOverButton.layer.cornerRadius=5
        stopButton.layer.cornerRadius=5
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.gameOneInstructions(notification:)), name: Notification.Name("gameOneInstructions"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setRandomBalloonGame(notification:)), name: Notification.Name("setRandomBalloonGame"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.exitScoreReportNewGame(notification:)), name: Notification.Name("exitScoreReportNewGame"), object: nil)
        
        headerLabel.adjustsFontSizeToFitWidth=true
        
        for button in myButtons{
            button.titleLabel!.adjustsFontSizeToFitWidth=true
            button.layer.cornerRadius=10
        }
       
        countLabel.adjustsFontSizeToFitWidth=true
        countdownTimer.adjustsFontSizeToFitWidth=true
        
        countdownTimer.layer.cornerRadius=10
        countLabel.layer.cornerRadius=10
    }
    
    @IBAction func easyPressed(_ sender: Any) {
        changeInterval(myNewInterval: 1.0, myButton: easy)
    }
    
    @IBAction func mediumPressed(_ sender: Any) {
        changeInterval(myNewInterval: 0.5, myButton: medium)
    }
    
    @IBAction func hardPressed(_ sender: Any) {
        changeInterval(myNewInterval: 0.25, myButton: hard)
    }
    
    @IBAction func extremePressed(_ sender: Any) {
        changeInterval(myNewInterval: 0.1, myButton: extreme)
    }
    
    func changeInterval(myNewInterval: Double, myButton: UIButton){
        if (stopButton.imageView!.image == UIImage(named: "pauseFilled")) && ((totalSec != 0)||(totalMin != 0)){
                secondInterval=myNewInterval
            
                myButton.backgroundColor=mediumBlue
            
            for i in 0...3{
                if(myButtons[i] != myButton){
                    myButtons[i].backgroundColor=originalButtonColors[i]
                }
            }
                balloonTimer.invalidate()
                scheduledAddBalloonTimer()
        }
    }
    
    func enableButtons(shouldEnable: Bool){
        for button in myButtons{
            button.isEnabled=shouldEnable
        }
    }
    
    @IBAction func xPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func gameOneInstructions(notification: Notification){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UserDefaults.standard.set("gameOneInstructions",forKey: "typeOKAlert")
            self.makeOKAlert()
        }
    }
    
    @objc func exitScoreReportNewGame(notification: Notification){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.makeGameSettingsAlert()
        }
    }
    
    @objc func appMovedToBackground() {
        enableButtons(shouldEnable: false)
        
        if (totalSec != 0)||(totalMin != 0){
            balloonTimer.invalidate()
            gameTimer.invalidate()
        }
        
        stopButton.setImage(nil, for: .normal)
        stopButton.setImage(UIImage(named: "resumeFilled"), for: .normal)
        
        print("handling random balloons game moved to background")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if totalMin == nil{
            makeGameSettingsAlert()
        }
    }
    
    func makeGameSettingsAlert(){
        UserDefaults.standard.set("game1", forKey: "gameNumber")
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "GameSettingsAlert") as! GameSettingsAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func makeScoreReportAlert(){
        UserDefaults.standard.set("game1", forKey: "gameNumber")
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "ScoreReportAlert") as! ScoreReportAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func resetForNewGame(){
        enableButtons(shouldEnable: true)
        stopButton.isEnabled=true
        increasingValue=0
        
        gameTimer.invalidate()
        balloonTimer.invalidate()
        
        for subview in gameView.subviews{
            if let item = subview as? UIImageView{
                item.removeFromSuperview()
            }
        }
        
        stopButton.setImage(UIImage(named: "pauseFilled"), for: .normal)
        
        for i in 0...3{
            myButtons[i].backgroundColor=originalButtonColors[i]
        }
        
        countLabel.text=""
        countLabel.textColor=UIColor.black
        countdownTimer.text=""
        countdownTimer.textColor=UIColor.black
    }
    
    @objc func setRandomBalloonGame(notification: Notification){
        resetForNewGame()
        
        var gameTime=UserDefaults.standard.string(forKey: "gameTime")
        var gameLevel=UserDefaults.standard.string(forKey: "gameLevel")
        
        switch(gameTime){
        case "30 Sec":
            totalMin=0
            totalSec=30
            
            var record=UserDefaults.standard.integer(forKey: "recordThirty")
            recordValue=record
        case "1 Min":
            totalMin=1
            totalSec=0
            
            var record=UserDefaults.standard.integer(forKey: "recordOneMin")
            recordValue=record
        case "5 Min":
            totalMin=5
            totalSec=0
            
            var record=UserDefaults.standard.integer(forKey: "recordFiveMin")
            recordValue=record
        default:
            print("error in setting min and sec and record values")
        }
        
        gameTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RandomBalloonsVC.descendingAction), userInfo: nil, repeats: true)
        
        switch(gameLevel){
        case "Easy":
            secondInterval=1
            easy.backgroundColor=UIColor(rgb: 0x1fc2ff)
        case "Medium":
            secondInterval=0.5
            medium.backgroundColor=UIColor(rgb: 0x1fc2ff)
        case "HARD":
            secondInterval=0.25
            hard.backgroundColor=UIColor(rgb: 0x1fc2ff)
        case "EXTREME":
            secondInterval=0.1
            extreme.backgroundColor=UIColor(rgb: 0x1fc2ff)
        default:
            secondInterval=0.25
            easy.backgroundColor=UIColor(rgb: 0x1fc2ff)
        }
        
        scheduledAddBalloonTimer()
    }
    
    func makeOKAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "OKAlert") as! OKAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @objc func descendingAction(){
        
        if (totalMin==0 && totalSec==0){ //when timer reaches zero, remove all balloons, stop timers, and set new values as records
            
            
            if (increasingValue>recordValue)||((recordValue==0)&&(increasingValue != 0)){
                var gameTime=UserDefaults.standard.string(forKey: "gameTime")
                
                switch(gameTime){
                case "30 Sec":
                    UserDefaults.standard.set(increasingValue, forKey: "recordThirty")
                case "1 Min":
                    UserDefaults.standard.set(increasingValue, forKey: "recordOneMin")
                case "5 Min":
                    UserDefaults.standard.set(increasingValue, forKey: "recordFiveMin")
                default:
                    print("error in setting the record values after game")
                }
            }
            //present alert with current score and record score
            Analytics.logEvent("playedPopBalloonsGame", parameters: nil)
            
            UserDefaults.standard.set(increasingValue, forKey: "currentScore")
            makeScoreReportAlert()
            resetForNewGame()
        }else{
            totalSec = totalSec - 1
            if totalSec<0{ //more than 59 seconds
                
                totalSec=totalSec + 60
                totalMin=totalMin-1
                displaying()
            }else if totalSec>=0 && totalMin>=0{
                displaying()
            }
        }
    }
    
    func displaying(){
        if totalMin<10{
            if totalSec<10{
                countdownTimer.text = String("  0\(Int(totalMin!)) : 0\(Int(totalSec!))  ")
                
                if totalMin==0{
                    countdownTimer.textColor=mediumBlue
                }
            } else{
                countdownTimer.text = String("  0\(Int(totalMin!)) : \(Int(totalSec!))  ")
                countdownTimer.textColor=UIColor.black
            }
        } else{
            if totalSec<10{
                countdownTimer.text = String("  \(Int(totalMin!)) : 0\(Int(totalSec!))  ")
                countdownTimer.textColor=UIColor.black
            } else{
                countdownTimer.text = String("  \(Int(totalMin!)) : \(Int(totalSec!))  ")
                countdownTimer.textColor=UIColor.black
            }
        }
    }// end of function
    
    func scheduledAddBalloonTimer(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        if (self.recordValue == 0)||(self.recordValue == nil){
            self.countLabel.text="  0  "
        }else{
            self.countLabel.text="  0/\(recordValue!)  "
        }
        
        displaying()
        
        balloonTimer = Timer.scheduledTimer(timeInterval: secondInterval, target: self, selector: #selector(self.addRandomBalloon), userInfo: nil, repeats: true)
    }
    
    @objc func addRandomBalloon(){
        var myImageView=UIImageView()
        
        var fullWidth=Int(gameView.frame.width)
        var fullHeight=Int(gameView.frame.height)
        
        var widthMin=Int(gameView.frame.width*0.2)
        var widthMax=Int(gameView.frame.width*0.3)
        var randomWidth = Int.random(in: widthMin...widthMax)
        var countdownLabelHeight=Int(countdownTimer.frame.height)
        
        var randomX=Int.random(in: 0...fullWidth-randomWidth)
        var randomY=Int.random(in: countdownLabelHeight...fullHeight-randomWidth)
        
        myImageView.frame=CGRect(x: randomX, y: randomY, width: randomWidth, height: randomWidth)
        myImageView.image = UIImage(imageLiteralResourceName: "greenBalloon").withRenderingMode(.alwaysTemplate)
        myImageView.setImageColor()
        myImageView.isUserInteractionEnabled=true

        gameView.addSubview(myImageView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (stopButton.imageView!.image == UIImage(named: "pauseFilled")) && ((totalSec != 0)||(totalMin != 0)){
            if let firstTouch = touches.first {
                let hitView = gameView.hitTest(firstTouch.location(in: gameView), with: event)
                
                //if view that was being pan gestured is a small blue circle view
                if let item = hitView as? UIImageView{
                    
                    guard let path = Bundle.main.path(forResource: "balloonPopping", ofType:"mp4") else {
                        debugPrint("mp4 not found")
                        return
                    }
                    
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    
                    let player = AVPlayer(url: URL(fileURLWithPath: path))
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = item.bounds
                    item.layer.addSublayer(playerLayer)
                    player.play()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Change `2.0` to the desired number of seconds.
                        // Code you want to be delayed
                        
                        item.removeFromSuperview()
                        self.increasingValue += 1
                        
                        if self.increasingValue>self.recordValue{
                            self.countLabel.text="  \(self.increasingValue)  "
                            self.countLabel.textColor=self.mediumBlue

                            var gameTime=UserDefaults.standard.string(forKey: "gameTime")
                                
                            switch(gameTime){
                            case "30 Sec":
                                UserDefaults.standard.set(self.increasingValue, forKey: "recordThirty")
                            case "1 Min":
                                UserDefaults.standard.set(self.increasingValue, forKey: "recordOneMin")
                            case "5 Min":
                                UserDefaults.standard.set(self.increasingValue, forKey: "recordFiveMin")
                            default:
                                print("error in setting the record values after game")
                            }
                            
                        }else if self.recordValue == 0{
                            self.countLabel.text="  \(self.increasingValue)  "
                            self.countLabel.textColor=UIColor.black
                        }else{
                            self.countLabel.text="  \(self.increasingValue)/\(self.recordValue!)  "
                            self.countLabel.textColor=UIColor.black
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    @IBAction func stopGame(_ sender: Any) {
        if stopButton.imageView!.image == UIImage(named: "pauseFilled"){ //pausing
            print("pausing")
            enableButtons(shouldEnable: false)
            
            if (totalSec != 0)||(totalMin != 0){
                balloonTimer.invalidate()
                gameTimer.invalidate()
            }
            
            stopButton.setImage(nil, for: .normal)
            stopButton.setImage(UIImage(named: "resumeFilled"), for: .normal)
        }else{
            print("resuming")
            enableButtons(shouldEnable: true)
            
            if (totalSec != 0)||(totalMin != 0){ //resuming
                gameTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RandomBalloonsVC.descendingAction), userInfo: nil, repeats: true)
                balloonTimer = Timer.scheduledTimer(timeInterval: secondInterval, target: self, selector: #selector(self.addRandomBalloon), userInfo: nil, repeats: true)
            }
            
            stopButton.setImage(UIImage(named: "pauseFilled"), for: .normal)
        }

    }
    
    @IBAction func startOverGame(_ sender: Any) {
        resetForNewGame()
        makeGameSettingsAlert()
    }
    
}

extension UIImageView{
    func setImageColor(){
        let myTempColors=[UIColor(rgb: 0xef4b4b), UIColor(rgb: 0xec8f6a), UIColor(rgb: 0xf9e090),  UIColor(rgb: 0xedaaaa), UIColor(rgb: 0xffdcf7), UIColor(rgb: 0xfce2ae), UIColor(rgb: 0xdc5353), UIColor(rgb: 0xf67e7d), UIColor(rgb: 0x9cf196), UIColor(rgb: 0xb6ffea), UIColor(rgb: 0x00dbcd), UIColor(rgb: 0x9cf196), UIColor(rgb: 0x5edfff), UIColor(rgb: 0xb2fcff), UIColor(rgb: 0xc6f1d6), UIColor(rgb: 0x9ea9f0), UIColor(rgb: 0xccc1ff)]
        
        var randomInt = Int.random(in: 0..<myTempColors.count)
        self.tintColor = myTempColors[randomInt]
    }
}
