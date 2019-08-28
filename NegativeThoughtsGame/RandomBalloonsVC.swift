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

class RandomBalloonsVC: UIViewController {

    var balloonTimer = Timer()
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediumBlue=UIColor(rgb: 0x1fc2ff)
        
        startOverButton.layer.cornerRadius=5
        stopButton.layer.cornerRadius=5
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setRandomBalloonGame(notification:)), name: Notification.Name("setRandomBalloonGame"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        makeGameSettingsAlert()
    }
    
    func makeGameSettingsAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "GameSettingsAlert") as! GameSettingsAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func resetForNewGame(){
        segmentedControl.isUserInteractionEnabled=true
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
        countdownTimer.text=""
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
            segmentedControl.selectedSegmentIndex = 0
        case "Medium":
            secondInterval=0.5
            segmentedControl.selectedSegmentIndex = 1
        case "HARD":
            secondInterval=0.25
            segmentedControl.selectedSegmentIndex = 2
        case "EXTREME":
            secondInterval=0.1
            segmentedControl.selectedSegmentIndex = 3
        default:
            secondInterval=0.25
            segmentedControl.selectedSegmentIndex = 2
        }
        
        
        scheduledAddBalloonTimer()
    }
    
    @objc func descendingAction(){
        
        if (totalMin==0 && totalSec==0){ //when timer reaches zero, remove all balloons, stop timers, and set new values as records
            resetForNewGame()
            
            if increasingValue>recordValue{
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
                countdownTimer.textColor=mediumBlue
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
        if self.recordValue != nil{
            self.countLabel.text="0/\(self.recordValue!)"
        }else{
            self.countLabel.text="0"
        }
        
        displaying()
        
        balloonTimer = Timer.scheduledTimer(timeInterval: secondInterval, target: self, selector: #selector(self.addRandomBalloon), userInfo: nil, repeats: true)
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        if (stopButton.titleLabel!.text == "  Pause  ")&&((totalSec != 0)||(totalMin != 0)){
                let segmentIndex = segmentedControl.selectedSegmentIndex
                
                switch(segmentIndex){
                case 0:
                    secondInterval=1
                case 1:
                    secondInterval=0.5
                case 2:
                    secondInterval=0.25
                case 3:
                    secondInterval=0.1
                default:
                    secondInterval=0.25
                }
                
                balloonTimer.invalidate()
                scheduledAddBalloonTimer()
            
        }
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
        if (stopButton.titleLabel!.text == "  Pause  ")&&((totalSec != 0)||(totalMin != 0)){
            if let firstTouch = touches.first {
                let hitView = gameView.hitTest(firstTouch.location(in: gameView), with: event)
                
                //if view that was being pan gestured is a small blue circle view
                if let item = hitView as? UIImageView{
                    
                    guard let path = Bundle.main.path(forResource: "balloonPopping", ofType:"mp4") else {
                        debugPrint("mp4 not found")
                        return
                    }
                    
                    
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
                            self.countLabel.text="\(self.increasingValue)"
                            self.countLabel.textColor=self.mediumBlue
                        }else if self.recordValue == 0{
                            self.countLabel.text="\(self.increasingValue)"
                            self.countLabel.textColor=UIColor.black
                        }else{
                            self.countLabel.text="\(self.increasingValue)/\(self.recordValue!)"
                            self.countLabel.textColor=UIColor.black
                        }
                        
                    }
                    
                }
            }
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
                balloonTimer = Timer.scheduledTimer(timeInterval: secondInterval, target: self, selector: #selector(self.addRandomBalloon), userInfo: nil, repeats: true)
                stopButton.setTitle("  Pause  ", for: .normal)
            }
        }

    }
    
    @IBAction func startOverGame(_ sender: Any) {
        resetForNewGame()
        makeGameSettingsAlert()
    }
    
}
