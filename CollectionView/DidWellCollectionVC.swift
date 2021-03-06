//
//  DidWellCollectionVC.swift
//  DayLights
//
//  Created by Audrey Ha on 8/9/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Firebase

class DidWellCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var leftCollectionView: UICollectionView!
    @IBOutlet weak var headerCategoryLabel: UILabel!
  
    
    var dayHighlightsArray=CoreDataHelper.retrieveDaylight()
    var leftEntries=[Daylight]()
    var rightEntries=[Daylight]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerCategoryLabel.adjustsFontSizeToFitWidth=true
        dayHighlightsArray=CoreDataHelper.retrieveDaylight()
        resetDaylightArrays()
        
        leftCollectionView.layer.cornerRadius=30

        leftCollectionView.dataSource=self
        leftCollectionView.delegate=self
        
        let width = self.view.bounds.width // This is the width of the superview, in your case probably the `UIViewController`
        let height = CGFloat(400) // Your desired height, if you want it to full the superview, use self.bounds.height
        let layout = leftCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height) // Sets the dimensions of your collection view cell.

        leftCollectionView.updateConstraintsIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showEntryAlert(notification:)), name: Notification.Name("showEntryAlert"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteDaylight(notification:)), name: Notification.Name("delete"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.editDaylight(notification:)), name: Notification.Name("editDaylight"), object: nil)

        Analytics.logEvent("viewedGallery", parameters: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dayHighlightsArray=CoreDataHelper.retrieveDaylight()
        resetDaylightArrays()
        leftCollectionView.reloadData()
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
        
        //COMMENT change to grateful/stressful
        switch(headerCategoryLabel.text){
        case "Gallery: Grateful Things":
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

        //COMMENT: change this to grateful and funny
        switch(headerCategoryLabel.text){
        case "Gallery: Things I Did Well":
            label.text = array[row].didWell
        case "Gallery: Grateful Moments":
            label.text = array[row].gratefulThing
        default:
            label.text = array[row].didWell
        }
        
        label.adjustsFontSizeToFitWidth=true
        label.numberOfLines=100
        label.font=UIFont(name: "Avenir", size: 17)
        label.textColor=UIColor.black
        
        image.addSubview(label)
    }
    
    func setImageColor(image: UIImageView){
        var myTempColors=[
            // red/orange/yellow/pink
            [UIColor(rgb: 0xfce1fb), UIColor(rgb: 0xef4b4b), UIColor(rgb: 0xff9369), UIColor(rgb: 0xf9e090),  UIColor(rgb: 0xedaaaa), UIColor(rgb: 0xffdcf7), UIColor(rgb: 0xfce2ae),  UIColor(rgb: 0xff5773), UIColor(rgb: 0xf67e7d)],
            
            // green/teal/blue
            [UIColor(rgb: 0xd9c1f7), UIColor(rgb: 0xb79af5), UIColor(rgb: 0x9792f7), UIColor(rgb: 0x7de8d4), UIColor(rgb: 0xb1f0ad), UIColor(rgb: 0xb6ffea), UIColor(rgb: 0x09d7e6), UIColor(rgb: 0x55cced), UIColor(rgb: 0x87e681), UIColor(rgb: 0x5edfff), UIColor(rgb: 0xb2fcff), UIColor(rgb: 0x91f2cf), UIColor(rgb: 0xc6f1d6), UIColor(rgb: 0xc2f0ff), UIColor(rgb: 0x9ccdff)]
            
        ]
        
        //COMMENT: Include colors for grateful/joyful
        var randomInt1 = Int.random(in: 0...1)
        switch(headerCategoryLabel.text){
        case "Gallery: Things I Did Well":
            randomInt1=0
        case "Gallery: Grateful Things":
            randomInt1=1
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
            
            var valueToSubtract=cell.leftHandImage.frame.width*1.6
            var min=0
            var max=Int(collectionView.frame.width-valueToSubtract)
            
            
            //COMMENT: CHANGE TO GRATEFUL
            if(headerCategoryLabel.text=="Gallery: Grateful Things"){
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
            
            //COMMENT: instead, add variables to cell for leftGrateful and leftJoyful
            cell.leftStressfulMoment=leftEntries[indexPath.row].gratefulThing ?? "No Grateful Thing Entered"
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
            
            //Add variables to cell for rightGrateful and rightDidWell
            cell.rightStressfulMoment=rightEntries[indexPath.row].gratefulThing ?? "No Grateful Thing Entered"
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

        //COMMENT: change from stressful to grateful
        switch(headerCategoryLabel.text){
        case "Gallery: Grateful Things":
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

