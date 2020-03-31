//
//  DragBalloonsVC.swift
//  DayLights
//
//  Created by Audrey Ha on 8/29/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import AudioToolbox
import Firebase

class DragBalloonsVC: UIViewController {

    var balloonTimer = Timer()
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var titleOfGame: UILabel!
    
    var secondInterval: Double!
    var totalMin: Int!
    var totalSec: Int!
    var recordValue: Int!
    var increasingValue=0
    var balloonWidth=80
    var gameTimer=Timer()
    var mediumBlue: UIColor!
    
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countdownTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       titleOfGame.adjustsFontSizeToFitWidth=true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        instructionsLabel.adjustsFontSizeToFitWidth=true
        gameView.isUserInteractionEnabled=true
        
        controlsView.layer.cornerRadius=10
        
        mediumBlue=UIColor(rgb: 0x1fc2ff)
        
        startOverButton.layer.cornerRadius=5
        stopButton.layer.cornerRadius=5
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.gameTwoInstructions(notification:)), name: Notification.Name("gameTwoInstructions"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setSecondBalloonGame(notification:)), name: Notification.Name("setSecondBalloonGame"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.exitScoreReportNewGame(notification:)), name: Notification.Name("exitScoreReportNewGame"), object: nil)
    }
    
    @IBAction func xPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func gameTwoInstructions(notification: Notification){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UserDefaults.standard.set("gameTwoInstructions",forKey: "typeOKAlert")
            self.makeOKAlert()
        }
    }
    
    func makeOKAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "OKAlert") as! OKAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @objc func exitScoreReportNewGame(notification: Notification){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.makeGameSettingsAlert()
        }
    }
    
    @objc func appMovedToBackground() {
        segmentedControl.isUserInteractionEnabled=false
        
        if (totalSec != 0)||(totalMin != 0){
            balloonTimer.invalidate()
            gameTimer.invalidate()
            stopButton.setTitle("  Resume  ", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        makeGameSettingsAlert()
    }
    
    func makeGameSettingsAlert(){
        UserDefaults.standard.set("game2", forKey: "gameNumber")
        let vc = storyboard!.instantiateViewController(withIdentifier: "GameSettingsAlert") as! GameSettingsAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func makeScoreReportAlert(){
        UserDefaults.standard.set("game2", forKey: "gameNumber")
        let vc = storyboard!.instantiateViewController(withIdentifier: "ScoreReportAlert") as! ScoreReportAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func resetForNewGame(){
        segmentedControl.isUserInteractionEnabled=true
        stopButton.isEnabled=true
        increasingValue=0
        
        gameTimer.invalidate()
        balloonTimer.invalidate()
        
        for subview in gameView.subviews{
            if let item = subview as? UIImageView{
                item.removeFromSuperview()
            }
        }
        
        stopButton.setTitle("  Pause  ", for: .normal)
        countLabel.text=""
        countLabel.textColor=UIColor.black
        countdownTimer.text=""
        countdownTimer.textColor=UIColor.black
    }
    
    @objc func setSecondBalloonGame(notification: Notification){
        resetForNewGame()
        
        var gameTime=UserDefaults.standard.string(forKey: "gameTime2")
        var gameLevel=UserDefaults.standard.string(forKey: "gameLevel2")
        
        switch(gameTime){
        case "30 Sec":
            totalMin=0
            totalSec=30
            
            var record=UserDefaults.standard.integer(forKey: "recordThirty2")
            recordValue=record
        case "1 Min":
            totalMin=1
            totalSec=0
            
            var record=UserDefaults.standard.integer(forKey: "recordOneMin2")
            recordValue=record
        case "5 Min":
            totalMin=5
            totalSec=0
            
            var record=UserDefaults.standard.integer(forKey: "recordFiveMin2")
            recordValue=record
        default:
            print("error in setting min and sec and record values")
        }
        
        gameTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RandomBalloonsVC.descendingAction), userInfo: nil, repeats: true)
        
        switch(gameLevel){
        case "Easy":
            secondInterval=2
            segmentedControl.selectedSegmentIndex = 0
        case "Medium":
            secondInterval=1.5
            segmentedControl.selectedSegmentIndex = 1
        case "HARD":
            secondInterval=1
            segmentedControl.selectedSegmentIndex = 2
        case "EXTREME":
            secondInterval=0.5
            segmentedControl.selectedSegmentIndex = 3
        default:
            secondInterval=1.5
            segmentedControl.selectedSegmentIndex = 2
        }
        
        
        scheduledAddBalloonTimer()
    }
    
    @objc func descendingAction(){
        
        if (totalMin==0 && totalSec==0){ //when timer reaches zero, remove all balloons, stop timers, and set new values as records
            
            
            if (increasingValue>recordValue)||((recordValue==0)&&(increasingValue != 0)){
                var gameTime=UserDefaults.standard.string(forKey: "gameTime2")
                
                switch(gameTime){
                case "30 Sec":
                    UserDefaults.standard.set(increasingValue, forKey: "recordThirty2")
                case "1 Min":
                    UserDefaults.standard.set(increasingValue, forKey: "recordOneMin2")
                case "5 Min":
                    UserDefaults.standard.set(increasingValue, forKey: "recordFiveMin2")
                default:
                    print("error in setting the record values after game")
                }
            }
            //present alert with current score and record score
            Analytics.logEvent("playedDragBalloonsGame", parameters: nil)
            
            UserDefaults.standard.set(increasingValue, forKey: "currentScore2")
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
                countdownTimer.text = String("0\(Int(totalMin!)) : 0\(Int(totalSec!))")
                
                if totalMin==0{
                    countdownTimer.textColor=mediumBlue
                }
            } else{
                countdownTimer.text = String("0\(Int(totalMin!)) : \(Int(totalSec!))")
                countdownTimer.textColor=UIColor.black
            }
        } else{
            if totalSec<10{
                countdownTimer.text = String("\(Int(totalMin!)) : 0\(Int(totalSec!))")
                countdownTimer.textColor=UIColor.black
            } else{
                countdownTimer.text = String("\(Int(totalMin!)) : \(Int(totalSec!))")
                countdownTimer.textColor=UIColor.black
            }
        }
    }// end of function
    
    func scheduledAddBalloonTimer(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        if (self.recordValue == 0)||(self.recordValue == nil){
            self.countLabel.text="0"
        }else{
            self.countLabel.text="0/\(recordValue!)"
        }
        
        displaying()
        
        balloonTimer = Timer.scheduledTimer(timeInterval: secondInterval, target: self, selector: #selector(self.addBalloonToDrag), userInfo: nil, repeats: true)
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        if (stopButton.titleLabel!.text == "  Pause  ")&&((totalSec != 0)||(totalMin != 0)){
            let segmentIndex = segmentedControl.selectedSegmentIndex
            
            switch(segmentIndex){
            case 0:
                secondInterval=2
            case 1:
                secondInterval=1.5
            case 2:
                secondInterval=1
            case 3:
                secondInterval=0.5
            default:
                secondInterval=1.5
            }
            
            balloonTimer.invalidate()
            scheduledAddBalloonTimer()
            
        }
    }
    
    @objc func addBalloonToDrag(){
        //COMMENT: These balloons instead have to be specific mood baloons. And they need the dragging gesture recognizer
        var myImageView=UIImageView()
        
        var fullWidth=Int(gameView.frame.width)
        var fullHeight=Int(gameView.frame.height)
        
        var widthMin=Int(gameView.frame.width*0.2)
        var widthMax=Int(gameView.frame.width*0.3)
        var countdownLabelHeight=Int(countdownTimer.frame.height)
        
        var randomX=Int.random(in: 0...fullWidth-balloonWidth)
        
        //make sure that there is space at the top and bottom for image views to be dragged up and down
        var randomY=Int.random(in: countdownLabelHeight+balloonWidth...fullHeight-balloonWidth-balloonWidth)
        
        myImageView.frame=CGRect(x: randomX, y: randomY, width: balloonWidth, height: balloonWidth)
        
        var moodBalloonNames=["emojiScale1","emojiScale2","emojiScale4","emojiScale5"]
        var randomMoodBalloonInt=Int.random(in:0...3)
        var randomBalloonName=moodBalloonNames[randomMoodBalloonInt]
        
        myImageView.image = UIImage(imageLiteralResourceName: randomBalloonName)
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(panGestureRecognizer)
        
        gameView.addSubview(myImageView)
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        if (stopButton.titleLabel!.text == "  Pause  ")&&((totalSec != 0)||(totalMin != 0)){
            let translation = sender.translation(in: gameView)
            if let viewDrag=sender.view as? UIImageView{
                viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
                sender.setTranslation(CGPoint.zero, in: gameView)
                
                if (viewDrag.image==UIImage(named: "emojiScale4"))||(viewDrag.image==UIImage(named: "emojiScale5")){
                    if (!viewDrag.superview!.bounds.intersection(viewDrag.frame).equalTo(viewDrag.frame))
                    {
                        if viewDrag.frame.minY <= gameView.frame.minY{
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            viewDrag.removeFromSuperview()
                            increaseScore()
                        }
                    }

                }else{
                    if (!viewDrag.superview!.bounds.intersection(viewDrag.frame).equalTo(viewDrag.frame))
                    {
                        if viewDrag.frame.minY >= gameView.frame.minY{
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            viewDrag.removeFromSuperview()
                            increaseScore()
                        }else{
                            
                            viewDrag.frame=CGRect(x: Int(viewDrag.frame.origin.x), y: 0, width: balloonWidth, height: balloonWidth)
                            
                        }
                    }
                }
            }
        }
    }

    func increaseScore(){
        self.increasingValue += 1
        
        if self.increasingValue>self.recordValue{
            self.countLabel.text="\(self.increasingValue)"
            self.countLabel.textColor=self.mediumBlue
            
            var gameTime=UserDefaults.standard.string(forKey: "gameTime2")
            
            switch(gameTime){
            case "30 Sec":
                UserDefaults.standard.set(self.increasingValue, forKey: "recordThirty2")
            case "1 Min":
                UserDefaults.standard.set(self.increasingValue, forKey: "recordOneMin2")
            case "5 Min":
                UserDefaults.standard.set(self.increasingValue, forKey: "recordFiveMin2")
            default:
                print("error in setting the record values after game")
            }
            
        }else if self.recordValue == 0{
            self.countLabel.text="\(self.increasingValue)"
            self.countLabel.textColor=UIColor.black
        }else{
            self.countLabel.text="\(self.increasingValue)/\(self.recordValue!)"
            self.countLabel.textColor=UIColor.black
        }
    }
    
    @IBAction func stopGame(_ sender: Any) {
        if stopButton.titleLabel!.text == "  Pause  "{ //pausing
            segmentedControl.isUserInteractionEnabled=false
            
            if (totalSec != 0)||(totalMin != 0){
                balloonTimer.invalidate()
                gameTimer.invalidate()
                stopButton.setTitle("  Resume  ", for: .normal)
            }
        }else{
            segmentedControl.isUserInteractionEnabled=true
            if (totalSec != 0)||(totalMin != 0){ //resuming
                gameTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RandomBalloonsVC.descendingAction), userInfo: nil, repeats: true)
                
                balloonTimer = Timer.scheduledTimer(timeInterval: secondInterval, target: self, selector: #selector(self.addBalloonToDrag), userInfo: nil, repeats: true)
                
                stopButton.setTitle("  Pause  ", for: .normal)
            }
        }
        
    }
    
    @IBAction func startOverGame(_ sender: Any) {
        resetForNewGame()
        makeGameSettingsAlert()
    }
    
}
