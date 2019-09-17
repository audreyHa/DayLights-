//
//  DidWellCollectionVC.swift
//  DayLights
//
//  Created by Audrey Ha on 8/9/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class DidWellCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var leftCollectionView: UICollectionView!
    @IBOutlet weak var headerCategoryLabel: UILabel!
    
    var dayHighlightsArray=CoreDataHelper.retrieveDaylight()
    var myColors=[[UIColor]]()
    var leftEntries=[Daylight]()
    var rightEntries=[Daylight]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerCategoryLabel.adjustsFontSizeToFitWidth=true
        resetDaylightArrays()
        
        leftCollectionView.dataSource=self
        leftCollectionView.delegate=self
        
        let width = self.view.bounds.width // This is the width of the superview, in your case probably the `UIViewController`
        let height = CGFloat(400) // Your desired height, if you want it to full the superview, use self.bounds.height
        let layout = leftCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height) // Sets the dimensions of your collection view cell.

        leftCollectionView.updateConstraintsIfNeeded()
        
        myColors=[
            //light
            [UIColor(rgb: 0xef4b4b), UIColor(rgb: 0xec8f6a), UIColor(rgb: 0xf2e3c9), UIColor(rgb: 0x7ecfc0), UIColor(rgb: 0xf9e090),  UIColor(rgb: 0xedaaaa), UIColor(rgb: 0x9cf196), UIColor(rgb: 0xffdcf7), UIColor(rgb: 0xfce2ae), UIColor(rgb: 0xb6ffea), UIColor(rgb: 0x8bbabb)],
            
            //dark
            [UIColor(rgb: 0x293462), UIColor(rgb: 0x216583), UIColor(rgb: 0xa72461), UIColor(rgb: 0x00818a), UIColor(rgb: 0x843b62), UIColor(rgb: 0x00a79d), UIColor(rgb: 0xcf455c), UIColor(rgb: 0x2d3561),  UIColor(rgb: 0x241663), UIColor(rgb: 0x226b80), UIColor(rgb: 0xdc5353), UIColor(rgb: 0x00818a), UIColor(rgb: 0x207561), UIColor(rgb: 0x366ed8), UIColor(rgb: 0x843b62), UIColor(rgb: 0x553c8b)]
        ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showEntryAlert(notification:)), name: Notification.Name("showEntryAlert"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteDaylight(notification:)), name: Notification.Name("delete"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.editDaylight(notification:)), name: Notification.Name("editDaylight"), object: nil)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "SkyDH.jpg")?.draw(in: self.view.bounds)
        
        switch(headerCategoryLabel.text){
        case "Gallery: Stressful Moments":
            UIImage(named: "PlanetDH.jpg")?.draw(in: self.view.bounds)
        case "Gallery: Joyful Moments":
            UIImage(named: "SunsetDH.png")?.draw(in: self.view.bounds)
        default:
            UIImage(named: "SkyDH.png")?.draw(in: self.view.bounds)
        }
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        
        leftCollectionView.backgroundColor=UIColor.clear
    }

    func resetDaylightArrays(){
        dayHighlightsArray.reverse()
        var count=0
        leftEntries=[]
        rightEntries=[]
        for daylight in dayHighlightsArray{
            if count%2 == 0{
                leftEntries.append(daylight)
            }else{
                rightEntries.append(daylight)
            }
            count+=1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        guard let identifier = segue.identifier,
            let destination = segue.destination as? ViewController
            else { return }
        
        switch identifier {
            // 2
            
        case "edit":
            var side=UserDefaults.standard.string(forKey: "sideInCell")
            var indexPathToDelete=UserDefaults.standard.integer(forKey: "rowOfPressedZoom")
            var daylightToEdit: Daylight?

            if side=="left"{
                print("side is left")
                daylightToEdit=leftEntries[indexPathToDelete]
            }else if side=="right"{
                print("side is right")
                daylightToEdit=rightEntries[indexPathToDelete]
            }
            
            
            // 3
            let destination = segue.destination as! ViewController
            // 4
            destination.daylight = daylightToEdit
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    @objc func editDaylight(notification: Notification){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "edit", sender: nil)
    }
    
    @objc func showEntryAlert(notification: Notification) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "EntryAlert") as! EntryAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @objc func deleteDaylight(notification: Notification) {
        
        var side=UserDefaults.standard.string(forKey: "sideInCell")
        var indexPathToDelete=UserDefaults.standard.integer(forKey: "rowOfPressedZoom")
        var daylightToDelete: Daylight?
        
        if side=="left"{
            print("side is left")
            daylightToDelete=leftEntries[indexPathToDelete]
        }else if side=="right"{
            print("side is right")
            daylightToDelete=rightEntries[indexPathToDelete]
        }
        
        if daylightToDelete != nil{
            CoreDataHelper.delete(daylight: daylightToDelete!)
            CoreDataHelper.saveDaylight()
            dayHighlightsArray=CoreDataHelper.retrieveDaylight()
            resetDaylightArrays()
        }

        leftCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var updatedDaylightsArray=[Daylight]()
        for daylight in dayHighlightsArray{
            if daylight.dateCreated! > Date(){
                updatedDaylightsArray.append(daylight)
            }
        }
        var number1=0
        
        switch(headerCategoryLabel.text){
        case "Gallery: Stressful Moments":
            if updatedDaylightsArray.count%2 == 0{
                number1=updatedDaylightsArray.count/2
            }else{
                number1=(updatedDaylightsArray.count+1)/2
            }
        default:
            if dayHighlightsArray.count%2 == 0{
                number1=dayHighlightsArray.count/2
            }else{
                number1=(dayHighlightsArray.count+1)/2
            }
        }
        
        return number1
    }
    
    func addLabel(image: UIImageView, array: [Daylight], row: Int, cell: LeftCollectionViewCell){
        for subview in image.subviews{
            if let item = subview as? UILabel{
                item.removeFromSuperview()
            }
        }
        
        for subview in image.subviews{
            if let item = subview as? UIButton{
                item.removeFromSuperview()
            }
        }
        
        var label = UILabel(frame: CGRect(x: image.frame.width*0.18, y: image.frame.height*0.17, width: image.frame.width*0.63, height: image.frame.height*0.59))
        label.textAlignment = NSTextAlignment.center

        switch(headerCategoryLabel.text){
        case "Gallery: Things I Did Well":
            label.text = array[row].didWell
        case "Gallery: Stressful Moments":
            label.text = array[row].funny
        default:
            label.text = array[row].didWell
        }
        
        label.adjustsFontSizeToFitWidth=true
        label.numberOfLines=100
        label.font=UIFont(name: "Avenir", size: 17)
        
        if myColors[1].contains(image.tintColor){
            label.textColor=UIColor.white
        }else{
            label.textColor=UIColor.black
        }
        
//        label.backgroundColor=UIColor.purple
        
        image.addSubview(label)
    }
    
    func setImageColor(image: UIImageView){
        var myTempColors=[
            // red/orange/yellow/pink
            [UIColor(rgb: 0xef4b4b), UIColor(rgb: 0xec8f6a), UIColor(rgb: 0xf9e090),  UIColor(rgb: 0xedaaaa), UIColor(rgb: 0xffdcf7), UIColor(rgb: 0xfce2ae), UIColor(rgb: 0xdc5353), UIColor(rgb: 0xcf455c), UIColor(rgb: 0xf67e7d)],
            
            // green/teal/blue
            [UIColor(rgb: 0x7ecfc0), UIColor(rgb: 0x9cf196), UIColor(rgb: 0xb6ffea), UIColor(rgb: 0x00818a), UIColor(rgb: 0x00a79d), UIColor(rgb: 0x226b80), UIColor(rgb: 0x00818a), UIColor(rgb: 0x9cf196), UIColor(rgb: 0x5edfff), UIColor(rgb: 0xb2fcff), UIColor(rgb: 0xe0f5b9), UIColor(rgb: 0xc6f1d6), UIColor(rgb: 0xdaf1f9), UIColor(rgb: 0x366ed8)],
            
            //dark navy/purples/magenta
            [UIColor(rgb: 0x293462), UIColor(rgb: 0x216583), UIColor(rgb: 0xa72461), UIColor(rgb: 0x843b62), UIColor(rgb: 0x241663), UIColor(rgb: 0x843b62), UIColor(rgb: 0x553c8b), UIColor(rgb: 0x9ea9f0), UIColor(rgb: 0xccc1ff), UIColor(rgb: 0xffeafe), UIColor(rgb: 0xab93c9), UIColor(rgb: 0xd698b9)]
            
        ]
        
        var randomInt1 = Int.random(in: 0...2)
        switch(headerCategoryLabel.text){
        case "Gallery: Things I Did Well":
            randomInt1=0
        case "Gallery: Stressful Moments":
            randomInt1=1
        case "Gallery: Joyful Moments":
            randomInt1=2
        default:
            randomInt1=0
        }
        
        let randomInt2 = Int.random(in: 0..<myTempColors[randomInt1].count)
        image.tintColor = myTempColors[randomInt1][randomInt2]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=leftCollectionView.dequeueReusableCell(withReuseIdentifier: "LeftCell", for: indexPath) as! LeftCollectionViewCell
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        
        cell.dateLabel.adjustsFontSizeToFitWidth=true
        
        func setLeftSide(){
            cell.leftHandImage.image=UIImage(named: "greenBalloon")
            
            var valueToSubtract=cell.leftHandImage.frame.width*1.4
            var min=0
            var max=Int(collectionView.frame.width-valueToSubtract)
            
            
            if(headerCategoryLabel.text=="Gallery: Stressful Moments"){
                min=Int(cell.leftHandImage.frame.width*0.4)
            }
            
            if min>max{
                min=0
            }
            
            var randomInt = Int.random(in: min..<max)
            
             cell.leftHandImage.frame=CGRect(x: CGFloat(randomInt), y: cell.leftHandImage.frame.origin.y, width: cell.leftHandImage.frame.width, height: cell.leftHandImage.frame.height)
            cell.leftZoom.frame=CGRect(x: cell.leftHandImage.frame.origin.x, y: cell.leftHandImage.frame.origin.y, width: cell.leftZoom.frame.width, height: cell.leftZoom.frame.height)
            
            cell.leftHandImage.setTemplateImage()
            setImageColor(image: cell.leftHandImage)
            addLabel(image: cell.leftHandImage, array: leftEntries, row: indexPath.row, cell: cell)
            
            cell.leftDate=dateformatter.string(for: leftEntries[indexPath.row].dateCreated)
            cell.leftDidWell=leftEntries[indexPath.row].didWell!
            cell.leftStressfulMoment=leftEntries[indexPath.row].stressfulMoment ?? "No Stressful Moment Entered"
        }
        
        func setRightSide(){
            cell.rightHandImage.image=UIImage(named: "greenBalloon")
            
            cell.rightHandImage.setTemplateImage()
            setImageColor(image: cell.rightHandImage)
            addLabel(image: cell.rightHandImage, array: rightEntries, row: indexPath.row, cell: cell)
            
            let leftDate = dateformatter.string(from: leftEntries[indexPath.row].dateCreated!)
            let rightDate=dateformatter.string(from: rightEntries[indexPath.row].dateCreated!)
            
            cell.dateLabel.text = ("\(leftDate)\n\(rightDate)")
            
            cell.rightDate=dateformatter.string(for: rightEntries[indexPath.row].dateCreated)
            cell.rightDidWell=rightEntries[indexPath.row].didWell!
            cell.rightStressfulMoment=rightEntries[indexPath.row].stressfulMoment ?? "No Stressful Moment Entered"
        }
        
        setLeftSide()
        
        if dayHighlightsArray.count%2 != 0{
            var oneMore=dayHighlightsArray.count+1
            var halfOneMore=oneMore/2
            
            if indexPath.row==(halfOneMore-1){
                cell.rightHandImage.image=nil
                print("handling last row")
                
                for subview in cell.rightHandImage.subviews{
                    if let item = subview as? UILabel{
                        item.removeFromSuperview()
                        print("removed label from final cell")
                    }
                }
                
                cell.rightZoom.isHidden=true

                let leftDate = dateformatter.string(from: leftEntries[indexPath.row].dateCreated!)
                cell.dateLabel.text = ("\(leftDate)")
            }else{
                cell.rightZoom.isHidden=false
                setRightSide()
            }
        }else{
            cell.rightZoom.isHidden=false
            setRightSide()
        }

        switch(headerCategoryLabel.text){
        case "Gallery: Stressful Moments":
            cell.dateLabel.textColor=UIColor.white
            cell.rightZoom.imageView?.setTemplateImage()
            cell.rightZoom.imageView?.tintColor=UIColor.white
            cell.leftZoom.imageView?.setTemplateImage()
            cell.leftZoom.imageView?.tintColor=UIColor.white
        default:
            cell.dateLabel.textColor=UIColor.black
        }

       
        cell.updateConstraintsIfNeeded()
       return cell
    }
}

extension UIImageView {
    func setTemplateImage() {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

