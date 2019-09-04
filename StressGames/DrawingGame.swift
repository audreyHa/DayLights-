//
//  DrawingGame.swift
//  DayLights
//
//  Created by Audrey Ha on 9/2/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class Canvas : UIView{
    override func draw(_ rect: CGRect){
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        var colors=[UIColor(rgb: 0xfa310a), UIColor(rgb: 0xff803f), UIColor(rgb: 0xffe23f), UIColor(rgb: 0xc8ff3f), UIColor(rgb: 0x3fd4ff), UIColor(rgb: 0x003f87), UIColor(rgb: 0x400087), UIColor(rgb: 0x000000)]
        
        var colorInteger=UserDefaults.standard.integer(forKey: "colorInteger")
        print("color integer: \(colorInteger)")
        context.setStrokeColor(colors[colorInteger].cgColor)
        
        
        var penWidth=UserDefaults.standard.integer(forKey: "penWidth")
        print("pen width: \(penWidth)")
        context.setLineWidth(CGFloat(penWidth))
        context.setLineCap(.round)
        
        lines.forEach{(line) in
            for (i, p) in line.enumerated(){
                if i==0{
                    context.move(to: p)
                }else{
                    context.addLine(to: p)
                }
            }
        }
        
        context.strokePath()
    }
    
    var lines=[[CGPoint]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point=touches.first?.location(in: self) else {return}
        
        guard var lastLine = lines.popLast() else {return}
        lastLine.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
}
class DrawingGame: UIViewController {

    @IBOutlet weak var containerDrawingView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var new: UIButton!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var navyButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    
    @IBOutlet weak var penButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    
    @IBOutlet weak var penSlider: UISlider!
    @IBOutlet weak var eraserSlider: UISlider!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var screenshotButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    
    
    var usingPen=true
    
    var canvas=Canvas()
    var colors=[UIColor(rgb: 0xfa310a), UIColor(rgb: 0xff803f), UIColor(rgb: 0xffe23f), UIColor(rgb: 0xc8ff3f), UIColor(rgb: 0x3fd4ff), UIColor(rgb: 0x003f87), UIColor(rgb: 0x400087), UIColor(rgb: 0x000000)]
    
    var buttons=[UIButton]()
    
    var plainColorImages=[UIImage(named: "redCircle"), UIImage(named: "orangeCircle"), UIImage(named: "yellowCircle"), UIImage(named: "greenCircle"), UIImage(named: "blueCircle"), UIImage(named: "navyCircle"), UIImage(named: "purpleCircle"), UIImage(named: "blackCircle")]
    
    var checkedColorImages=[UIImage(named: "redCheck"), UIImage(named: "orangeCheck"), UIImage(named: "yellowCheck"), UIImage(named: "greenCheck"), UIImage(named: "blueCheck"), UIImage(named: "navyCheck"), UIImage(named: "purpleCheck"), UIImage(named: "blackCheck")]
    
    
//    var color=UIColor.black
//    var brushWidth: CGFloat=10.0
//    var eraserWidth: CGFloat=10.0
//    var opacity: CGFloat=1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(4, forKey: "colorInteger")
        UserDefaults.standard.set(10, forKey: "penWidth")
        
        eraserButton.layer.cornerRadius=5
        penButton.layer.cornerRadius=5
        blackButton.setImage(checkedColorImages[7], for: .normal)
        
        penSlider.minimumValue=5
        penSlider.maximumValue=25
        eraserSlider.minimumValue=5
        eraserSlider.maximumValue=25
        
        penSlider.setValue(10, animated: true)
        eraserSlider.setValue(10, animated: true)
        
        buttons=[redButton, orangeButton, yellowButton, greenButton, blueButton, navyButton, purpleButton, blackButton]
        
        penButton.backgroundColor=colors[4]
        
        penSlider.setThumbImage(UIImage(named: "bluePlayBar"), for: .normal)
        eraserSlider.setThumbImage(UIImage(named: "bluePlayBar"), for: .normal)
        
        screenshotButton.layer.cornerRadius=10
        clearAllButton.layer.cornerRadius=10
        new.layer.cornerRadius=10

    }

    override func viewDidAppear(_ animated: Bool) {
        canvas.backgroundColor = .red
        canvas.frame=containerDrawingView.frame
        
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector(checkAction))
//        containerDrawingView.addGestureRecognizer(gesture)
        
        view.addSubview(canvas)
        print("added subview")
    }
    
    //track finger as we move across screen
    var lines=[[CGPoint]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        lines.append([CGPoint]())
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point=touches.first?.location(in: canvas) else {return}

        guard var lastLine = lines.popLast() else {return}
        lastLine.append(point)
        lines.append(lastLine)

        
        //need to redraw line(s) as the line array gets points appended to it
        canvas.setNeedsDisplay()
    }
    
//    @objc func checkAction(sender : UITapGestureRecognizer) {
//        print("tapped")
//
//        var location=sender.location(in: canvas)
//        var offsetLocation=CGPoint(x: location.x+1, y: location.y+1)
//        drawLine(fromPoint: location, toPoint: offsetLocation)
//
//        guard var lastLine = lines.popLast() else {return}
//        lastLine.append(location)
//        lastLine.append(offsetLocation)
//        lines.append(lastLine)
//    }
    
    func setColor(indexPath: Int){
        UserDefaults.standard.set(indexPath, forKey: "colorInteger")
        
        for i in 0...7{
            if i != indexPath{
                buttons[i].setImage(plainColorImages[i], for: .normal)
            }
        }
        
        buttons[indexPath].setImage(checkedColorImages[indexPath], for: .normal)
        
        usingPen=true
        penButton.backgroundColor=colors[4]
        eraserButton.backgroundColor = .groupTableViewBackground
    }
    
    @IBAction func penPressed(_ sender: Any) {
        usingPen=true
        penButton.backgroundColor=colors[4]
        eraserButton.backgroundColor = .clear
    }
    
    @IBAction func eraserPressed(_ sender: Any) {
        usingPen=false
        
        eraserButton.backgroundColor=colors[4]
        penButton.backgroundColor = .clear
        
        for i in 0...buttons.count-1{
            buttons[i].setImage(plainColorImages[i], for: .normal)
        }
    }
    
    @IBAction func penSliderValueChanged(_ sender: Any) {
        //COMMENT: Need to set brush width in user defaults
//        brushWidth=CGFloat(penSlider.value)
    }
    
    @IBAction func eraserSliderValueChanged(_ sender: Any) {
        //COMMENT: set eraser width in user defaults
//        eraserWidth=CGFloat(eraserSlider.value)
    }
    
    @IBAction func redPressed(_ sender: Any) {
        
        setColor(indexPath: 0)
    }
    
    @IBAction func orangePressed(_ sender: Any) {
        setColor(indexPath: 1)
    }
    
    @IBAction func yellowPressed(_ sender: Any) {
        setColor(indexPath: 2)
    }
    
    @IBAction func greenPressed(_ sender: Any) {
        setColor(indexPath: 3)
    }
    
    @IBAction func bluePressed(_ sender: Any) {
        setColor(indexPath: 4)
    }
    
    @IBAction func navyPressed(_ sender: Any) {
        setColor(indexPath: 5)
    }
    
    @IBAction func purplePressed(_ sender: Any) {
        setColor(indexPath: 6)
    }
    
    @IBAction func blackPressed(_ sender: Any) {
        setColor(indexPath: 7)
    }
    
    @IBAction func screenshotPressed(_ sender: Any) {
    }
    
    @IBAction func clearAllPressed(_ sender: Any) {
        print("clear all pressed")
        lines.removeAll()

    }
    
    @IBAction func undoPressed(_ sender: Any) {
        print("undo pressed")
        lines.popLast()
        
    }
}
