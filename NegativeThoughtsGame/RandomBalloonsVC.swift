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

    var timer = Timer()
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var secondInterval: Double!
    var totalMin: Int!
    var totalSec: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc func setRandomBalloonGame(notification: Notification){
        var gameTime=UserDefaults.standard.string(forKey: "gameTime")
        var gameLevel=UserDefaults.standard.string(forKey: "gameLevel")
        
        switch(gameTime){
        case "30 Sec":
            totalMin=0
            totalSec=30
        case "1 Min":
            totalMin=1
            totalSec=0
        case "5 Min":
            totalMin=5
            totalSec=0
        default:
            totalMin=1
            totalSec=0
        }
        
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
    
    func scheduledAddBalloonTimer(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: secondInterval, target: self, selector: #selector(self.addRandomBalloon), userInfo: nil, repeats: true)
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
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
        
        timer.invalidate()
        scheduledAddBalloonTimer()
    }
    
    func segmentedControlValueChanged(){
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
        
        timer.invalidate()
        scheduledAddBalloonTimer()
    }
    
    @objc func addRandomBalloon(){
        var myImageView=UIImageView()
        
        var fullWidth=Int(gameView.frame.width)
        var fullHeight=Int(gameView.frame.height)
        
        var widthMin=Int(gameView.frame.width*0.2)
        var widthMax=Int(gameView.frame.width*0.3)
        var randomWidth = Int.random(in: widthMin...widthMax)
        
        var randomX=Int.random(in: 0...fullWidth-randomWidth)
        var randomY=Int.random(in: 0...fullHeight-randomWidth)
        
        myImageView.frame=CGRect(x: randomX, y: randomY, width: randomWidth, height: randomWidth)
        myImageView.image = UIImage(imageLiteralResourceName: "greenBalloon").withRenderingMode(.alwaysTemplate)
        myImageView.setImageColor()
        myImageView.isUserInteractionEnabled=true
        gameView.addSubview(myImageView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
                }
                
            }
        }
    }
    
    @IBAction func stopGame(_ sender: Any) {
        for subview in gameView.subviews{
            if let item = subview as? UIImageView{
                item.removeFromSuperview()
            }
        }
        
        timer.invalidate()
    }
    
    @IBAction func startOverGame(_ sender: Any) {
        for subview in gameView.subviews{
            if let item = subview as? UIImageView{
                item.removeFromSuperview()
            }
        }
        
        segmentedControlValueChanged()
    }
    
}
