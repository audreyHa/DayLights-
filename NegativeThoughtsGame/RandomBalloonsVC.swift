//
//  RandomBalloonsVC.swift
//  DayLights
//
//  Created by Audrey Ha on 8/21/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class RandomBalloonsVC: UIViewController {

    var timer = Timer()
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var secondInterval: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        switch(segmentIndex){
        case 0:
            secondInterval=1
        case 1:
            secondInterval=0.5
        case 2:
            secondInterval=0.25
        case 3:
            secondInterval=0.07
        default:
            secondInterval=0.25
        }

        scheduledAddBalloonTimer()
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        switch(segmentIndex){
        case 0:
            secondInterval=1        case 1:
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
        var widthMax=Int(gameView.frame.width*0.4)
        var randomWidth = Int.random(in: widthMin...widthMax)
        
        var randomX=Int.random(in: 0...fullWidth-randomWidth)
        var randomY=Int.random(in: 0...fullHeight-randomWidth)
        
        myImageView.frame=CGRect(x: randomX, y: randomY, width: randomWidth, height: randomWidth)
        myImageView.image = UIImage(imageLiteralResourceName: "greenBalloon").withRenderingMode(.alwaysTemplate)
        myImageView.setImageColor()
        myImageView.isUserInteractionEnabled=true
        gameView.addSubview(myImageView)
    }

    func scheduledAddBalloonTimer(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: secondInterval, target: self, selector: #selector(self.addRandomBalloon), userInfo: nil, repeats: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let firstTouch = touches.first {
            let hitView = gameView.hitTest(firstTouch.location(in: gameView), with: event)
            
            //if view that was being pan gestured is a small blue circle view
            if let item = hitView as? UIImageView{
                item.removeFromSuperview()
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
