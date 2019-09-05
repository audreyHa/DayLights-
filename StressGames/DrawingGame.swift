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
        
        var colors=[UIColor(rgb: 0xfa310a), UIColor(rgb: 0xff803f), UIColor(rgb: 0xffe23f), UIColor(rgb: 0x85F74D), UIColor(rgb: 0x3fd4ff), UIColor(rgb: 0x003f87), UIColor(rgb: 0x400087), UIColor(rgb: 0x000000)]
        
        context.setLineCap(.round)
        
        lines.forEach{(line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            
            for (i, p) in line.points.enumerated(){
                if i==0{
                    context.move(to: p)
                }else{
                    context.addLine(to: p)
                }
            }
            
            context.strokePath()
        }
        
    }
    
    var lines=[Line]()
    var addedTapGestureRecognizer=false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(addedTapGestureRecognizer==false){
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(canvasTapped(sender:)))
            self.addGestureRecognizer(gesture)
            addedTapGestureRecognizer=true
        }
        
        
        var colors=[UIColor(rgb: 0xfa310a), UIColor(rgb: 0xff803f), UIColor(rgb: 0xffe23f), UIColor(rgb: 0x85F74D), UIColor(rgb: 0x3fd4ff), UIColor(rgb: 0x003f87), UIColor(rgb: 0x400087), UIColor(rgb: 0x000000)]
        
        switch(UserDefaults.standard.bool(forKey: "usingPen")){
        case false:
            var eraserWidth=UserDefaults.standard.integer(forKey: "eraserWidth")
            
            lines.append(Line.init(strokeWidth: Float(eraserWidth), color: UIColor.white, points: []))

        default:
            var penWidth=UserDefaults.standard.integer(forKey: "penWidth")
            
            var colorInteger=UserDefaults.standard.integer(forKey: "colorInteger")
            
            lines.append(Line.init(strokeWidth: Float(penWidth), color: colors[colorInteger], points: []))
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point=touches.first?.location(in: self) else {return}
        
        guard var lastLine = lines.popLast() else {return}
        lastLine.points.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    func undo(){
        lines.popLast()
        setNeedsDisplay()
    }
    
    func clearAll(){
        lines.removeAll()
        setNeedsDisplay()
    }
    
    func makeScreenshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { (context) in
            self.layer.render(in: context.cgContext)
        }
    }
    
    func getAlphaNumericValue(yourString: String) -> String{
        let unsafeChars = CharacterSet.alphanumerics.inverted  // Remove the .inverted to get the opposite result.
        
        let cleanChars  = yourString.components(separatedBy: unsafeChars).joined(separator: "")
        return cleanChars
    }

    func checkIfScreenshot(labelText: String){
        if lines.count>0{
            var drawing=CoreDataHelper.newDrawing()
            
            var imageToSave=makeScreenshot()
            
            // get the documents directory url
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // choose a name for your image
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh/mm/ss"
            let dateDrawingGame=dateformatter.string(from: Date())
            let combinedFileName="\(labelText)\(dateDrawingGame)"
            
            let fileName = "\(getAlphaNumericValue(yourString: combinedFileName)).jpg"
            print("file name: \(fileName)")
            
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = imageToSave.jpegData(compressionQuality:  1.0),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print("drawing game image saved")
                    
                    drawing.filename=fileName
                    drawing.prompt=labelText
                    
                    CoreDataHelper.saveDaylight()
                } catch {
                    print("error saving file:", error)
                }
            }
            
            clearAll()
        }else{
            print("not saving image to documents directory because there are 0 lines in lines array")
        }
    }

    @objc func canvasTapped(sender : UITapGestureRecognizer) {
        print("tapped")
        
        var location=sender.location(in: self)
        var offsetLocation=CGPoint(x: location.x+1, y: location.y+1)
        
        switch(UserDefaults.standard.bool(forKey: "usingPen")){
        case false:
            var eraserWidth=UserDefaults.standard.integer(forKey: "eraserWidth")
            
            lines.append(Line.init(strokeWidth: Float(eraserWidth), color: UIColor.white, points: [location, offsetLocation]))
            setNeedsDisplay()
        default:
            var penWidth=UserDefaults.standard.integer(forKey: "penWidth")
            
            var colorInteger=UserDefaults.standard.integer(forKey: "colorInteger")
            
            var colors=[UIColor(rgb: 0xfa310a), UIColor(rgb: 0xff803f), UIColor(rgb: 0xffe23f), UIColor(rgb: 0x85F74D), UIColor(rgb: 0x3fd4ff), UIColor(rgb: 0x003f87), UIColor(rgb: 0x400087), UIColor(rgb: 0x000000)]
            
            lines.append(Line.init(strokeWidth: Float(penWidth), color: colors[colorInteger], points: [location, offsetLocation]))
            setNeedsDisplay()
        }
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

    var canvas=Canvas()
    var colors=[UIColor(rgb: 0xfa310a), UIColor(rgb: 0xff803f), UIColor(rgb: 0xffe23f), UIColor(rgb: 0x85F74D), UIColor(rgb: 0x3fd4ff), UIColor(rgb: 0x003f87), UIColor(rgb: 0x400087), UIColor(rgb: 0x000000)]
    
    var buttons=[UIButton]()
    
    var plainColorImages=[UIImage(named: "redCircle"), UIImage(named: "orangeCircle"), UIImage(named: "yellowCircle"), UIImage(named: "greenCircle"), UIImage(named: "blueCircle"), UIImage(named: "navyCircle"), UIImage(named: "purpleCircle"), UIImage(named: "blackCircle")]
    
    var checkedColorImages=[UIImage(named: "redCheck"), UIImage(named: "orangeCheck"), UIImage(named: "yellowCheck"), UIImage(named: "greenCheck"), UIImage(named: "blueCheck"), UIImage(named: "navyCheck"), UIImage(named: "purpleCheck"), UIImage(named: "blackCheck")]
    
    var adjectives=["luxurious","odd","dangerous","enthusiastic","majestic","complex","jittery","pink","screeching","sophisticated","terrific","boring","pink","mushy","disgusting","little","giant","elegant","energetic","awesome","creepy","imperfect","cool","educated","frightening","tough","bored","secretive","attractive","outgoing","interesting","cooperative","helpful","delightful","talented","quirky","intelligent","creative","athletic","artistic","whimsical","imaginary","enormous","shiny","polite","healthy","great","snobbish","royal","flawless","hungry","angry","groovy","snotty","calm","impolite","colossal","bright","special","charming"]

    var animals=["monsters","antelope","octopus","lions","aardvarks","polar bears","deer","rabbits","ground hogs","eagles","bears","mouse","pony","llama","beetle","donkey","zebra","parrots","racooons","bats","wolf","panthers","coyote","camels","birds","lizards","frogs","buffalo","peacocks","cats","fish","elephants","tigers","snakes","turtles","wolves","rhinoceros","foxes","frogs","squirrels","sharks","dolphins","leopards","giraffe","otters","hippos","crocodiles","alligators","owls"]
    
    func randomAnimalDrawingPrompt(){
        canvas.checkIfScreenshot(labelText: label.text ?? "Drawing Game")
        
        var adjectiveInt=Int.random(in: 0...adjectives.count-1)
        var animalInt=Int.random(in: 0...animals.count-1)
        label.text="\(adjectives[adjectiveInt].capitalized) \(animals[animalInt].capitalized)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        randomAnimalDrawingPrompt()
        
        UserDefaults.standard.set(7, forKey: "colorInteger")
        UserDefaults.standard.set(10, forKey: "penWidth")
        UserDefaults.standard.set(10, forKey: "eraserWidth")
        UserDefaults.standard.set(true, forKey: "usingPen")
        
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

        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func appMovedToBackground() {
        canvas.checkIfScreenshot(labelText: label.text ?? "Drawing Game")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        canvas.checkIfScreenshot(labelText: label.text ?? "Drawing Game")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        canvas.backgroundColor = .white
        canvas.frame=containerDrawingView.frame
        
        view.addSubview(canvas)
        print("added subview")
    }
    
    func setColor(indexPath: Int){
        UserDefaults.standard.set(indexPath, forKey: "colorInteger")
        
        for i in 0...7{
            if i != indexPath{
                buttons[i].setImage(plainColorImages[i], for: .normal)
            }
        }
        
        buttons[indexPath].setImage(checkedColorImages[indexPath], for: .normal)
        
        UserDefaults.standard.set(true, forKey: "usingPen")
        penButton.backgroundColor=colors[4]
        eraserButton.backgroundColor = .groupTableViewBackground
    }
    
    func setPen(){
        UserDefaults.standard.set(true, forKey: "usingPen")
        penButton.backgroundColor=colors[4]
        eraserButton.backgroundColor = .clear
        
        var lastColorInteger=UserDefaults.standard.integer(forKey: "colorInteger")
        
        for i in 0...7{
            if i != lastColorInteger{
                buttons[i].setImage(plainColorImages[i], for: .normal)
            }
        }
        
        buttons[lastColorInteger].setImage(checkedColorImages[lastColorInteger], for: .normal)
    }
    
    func setEraser(){
        UserDefaults.standard.set(false, forKey: "usingPen")
        
        eraserButton.backgroundColor=colors[4]
        penButton.backgroundColor = .clear
        
        for i in 0...buttons.count-1{
            buttons[i].setImage(plainColorImages[i], for: .normal)
        }
    }
    
    @IBAction func newPressed(_ sender: Any) {
        randomAnimalDrawingPrompt()
    }
    
    @IBAction func penPressed(_ sender: Any) {
        setPen()
    }
    
    
    @IBAction func eraserPressed(_ sender: Any) {
        setEraser()
    }
    
    @IBAction func penSliderValueChanged(_ sender: Any) {
        UserDefaults.standard.set(penSlider.value, forKey: "penWidth")
        
        setPen()
    }
    
    @IBAction func eraserSliderValueChanged(_ sender: Any) {
        UserDefaults.standard.set(eraserSlider.value, forKey: "eraserWidth")
        
        setEraser()
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
        var screenshottedDrawing=canvas.makeScreenshot()
        UIImageWriteToSavedPhotosAlbum(screenshottedDrawing, nil, nil, nil);
    }
    
    @IBAction func clearAllPressed(_ sender: Any) {
        print("clear all pressed")
        canvas.clearAll()
    }
    
    @IBAction func undoPressed(_ sender: Any) {
        print("undo pressed")
        canvas.undo()
    }
}

