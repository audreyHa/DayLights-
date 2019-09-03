//
//  DrawingGame.swift
//  DayLights
//
//  Created by Audrey Ha on 9/2/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

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
    
    var usingPen=true
    
    var canvas=UIImageView()
    var colors=[UIColor(rgb: 0xfa310a), UIColor(rgb: 0xff803f), UIColor(rgb: 0xffe23f), UIColor(rgb: 0xc8ff3f), UIColor(rgb: 0x3fd4ff), UIColor(rgb: 0x003f87), UIColor(rgb: 0x400087), UIColor(rgb: 0x000000)]
    
    var buttons=[UIButton]()
    
    var plainColorImages=[UIImage(named: "redCircle"), UIImage(named: "orangeCircle"), UIImage(named: "yellowCircle"), UIImage(named: "greenCircle"), UIImage(named: "blueCircle"), UIImage(named: "navyCircle"), UIImage(named: "purpleCircle"), UIImage(named: "blackCircle")]
    
    var checkedColorImages=[UIImage(named: "redCheck"), UIImage(named: "orangeCheck"), UIImage(named: "yellowCheck"), UIImage(named: "greenCheck"), UIImage(named: "blueCheck"), UIImage(named: "navyCheck"), UIImage(named: "purpleCheck"), UIImage(named: "blackCheck")]
    
    var color=UIColor.black
    var brushWidth: CGFloat=10.0
    var eraserWidth: CGFloat=10.0
    var opacity: CGFloat=1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eraserButton.layer.cornerRadius=10
        penButton.layer.cornerRadius=10
        
        penSlider.minimumValue=5
        penSlider.maximumValue=15
        eraserSlider.minimumValue=5
        eraserSlider.maximumValue=15
        
        penSlider.setValue(10, animated: true)
        eraserSlider.setValue(10, animated: true)
        
        buttons=[redButton, orangeButton, yellowButton, greenButton, blueButton, navyButton, purpleButton, blackButton]
        
        penSlider.setThumbImage(UIImage(named: "redPlayBar"), for: .normal)
        eraserSlider.setThumbImage(UIImage(named: "navyPlayBar"), for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        canvas.backgroundColor = .red
        canvas.frame=containerDrawingView.frame
        view.addSubview(canvas)
        print("added subview")
    }
    
    //track finger as we move across screen
    var lines=[[CGPoint]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint){
        UIGraphicsBeginImageContext(canvas.frame.size)
        guard let context=UIGraphicsGetCurrentContext() else{
            return
        }
        
        canvas.image?.draw(in:canvas.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        
        if usingPen==true{
            context.setLineWidth(brushWidth)
            context.setStrokeColor(color.cgColor)
        }else{
            context.setLineWidth(eraserWidth)
            context.setStrokeColor(UIColor.white.cgColor)
        }
        
        
        context.strokePath()
        canvas.image=UIGraphicsGetImageFromCurrentImageContext()
        canvas.alpha=opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point=touches.first?.location(in: canvas) else {return}

        guard var lastLine = lines.popLast() else {return}
        lastLine.append(point)
        lines.append(lastLine)
        
        if lastLine.count>1{
            var totalCount=lastLine.count
            drawLine(fromPoint: lastLine[totalCount-2], toPoint: lastLine[totalCount-1])
        }
        
        //need to redraw line(s) as the line array gets points appended to it
        canvas.setNeedsDisplay()
    }
    
    func setColor(indexPath: Int){
        color=colors[indexPath]
    
        for i in 0...7{
            if i != indexPath{
                buttons[i].setImage(plainColorImages[i], for: .normal)
            }
        }
        
        buttons[indexPath].setImage(checkedColorImages[indexPath], for: .normal)
        
        usingPen=true
        penButton.backgroundColor=colors[2]
        eraserButton.backgroundColor = .groupTableViewBackground
    }
    
    @IBAction func penPressed(_ sender: Any) {
        usingPen=true
        penButton.backgroundColor=colors[2]
        eraserButton.backgroundColor = .groupTableViewBackground
    }
    
    @IBAction func eraserPressed(_ sender: Any) {
        usingPen=false
        
        eraserButton.backgroundColor=colors[2]
        penButton.backgroundColor = .groupTableViewBackground
    }
    
    @IBAction func penSliderValueChanged(_ sender: Any) {
        brushWidth=CGFloat(penSlider.value)
    }
    
    @IBAction func eraserSliderValueChanged(_ sender: Any) {
        eraserWidth=CGFloat(eraserSlider.value)
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
    
    
}
