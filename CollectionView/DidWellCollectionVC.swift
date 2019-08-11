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
    
    var dayHighlightsArray=CoreDataHelper.retrieveDaylight()
    var myColors=[[UIColor]]()
    var leftEntries=[Daylight]()
    var rightEntries=[Daylight]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayHighlightsArray.reverse()
        var count=0
        for daylight in dayHighlightsArray{
            if count%2 == 0{
                leftEntries.append(daylight)
            }else{
                rightEntries.append(daylight)
            }
            count+=1
        }

        leftCollectionView.dataSource=self
        leftCollectionView.delegate=self
        
        myColors=[
            [UIColor(rgb: 0xef4b4b), UIColor(rgb: 0xec8f6a), UIColor(rgb: 0xf2e3c9), UIColor(rgb: 0x7ecfc0), UIColor(rgb: 0xf9e090),  UIColor(rgb: 0xedaaaa), UIColor(rgb: 0x9cf196), UIColor(rgb: 0xffdcf7), UIColor(rgb: 0xfce2ae), UIColor(rgb: 0xb6ffea), UIColor(rgb: 0x8bbabb)],
            
            [UIColor(rgb: 0x293462), UIColor(rgb: 0x216583), UIColor(rgb: 0xa72461), UIColor(rgb: 0x00818a), UIColor(rgb: 0x843b62), UIColor(rgb: 0x00a79d), UIColor(rgb: 0xcf455c), UIColor(rgb: 0x2d3561),  UIColor(rgb: 0x241663), UIColor(rgb: 0x226b80), UIColor(rgb: 0xdc5353), UIColor(rgb: 0x00818a)]
        ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showEntryAlert(notification:)), name: Notification.Name("showEntryAlert"), object: nil)
    }
    
    @objc func showEntryAlert(notification: Notification) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "EntryAlert") as! EntryAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var number1=0
        if dayHighlightsArray.count%2 == 0{
            number1=dayHighlightsArray.count/2
        }else{
            number1=(dayHighlightsArray.count+1)/2
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
        
        var label = UILabel(frame: CGRect(x: image.frame.width*0.18, y: image.frame.height*0.15, width: image.frame.width*0.63, height: image.frame.height*0.59))
        label.textAlignment = NSTextAlignment.center

        label.text = array[row].didWell
        label.adjustsFontSizeToFitWidth=true
        label.numberOfLines=100
        label.font=UIFont(name: "Avenir", size: 17)
        
        if myColors[1].contains(image.tintColor){
            label.textColor=UIColor.white
        }else{
            label.textColor=UIColor.black
        }
        
        image.addSubview(label)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=leftCollectionView.dequeueReusableCell(withReuseIdentifier: "LeftCell", for: indexPath) as! LeftCollectionViewCell
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        
        cell.dateLabel.adjustsFontSizeToFitWidth=true
        
        func setLeftSide(){
            cell.leftHandImage.image=UIImage(named: "greenBalloon")
            
            let valueToSubtract=cell.leftHandImage.frame.width*1.3
            let min=Int(cell.leftHandImage.frame.width*0.3)
            let max=Int(collectionView.frame.width-valueToSubtract)
            let randomInt = Int.random(in: min..<max)
            cell.leftHandImage.frame=CGRect(x: CGFloat(randomInt), y: cell.leftHandImage.frame.origin.y, width: cell.leftHandImage.frame.width, height: cell.leftHandImage.frame.height)
            cell.leftZoom.frame=CGRect(x: cell.leftHandImage.frame.origin.x, y: cell.leftHandImage.frame.origin.y, width: cell.leftZoom.frame.width, height: cell.leftZoom.frame.height)
            
            cell.leftHandImage.setImageColor()
            addLabel(image: cell.leftHandImage, array: leftEntries, row: indexPath.row, cell: cell)
            
            cell.leftDate=dateformatter.string(for: leftEntries[indexPath.row].dateCreated)
            cell.leftDidWell=leftEntries[indexPath.row].didWell!
            cell.leftGrateful=leftEntries[indexPath.row].gratefulThing!
            cell.leftJoyful=leftEntries[indexPath.row].funny
        }
        
        func setRightSide(){
            cell.rightHandImage.image=UIImage(named: "greenBalloon")

            cell.rightHandImage.setImageColor()
            addLabel(image: cell.rightHandImage, array: rightEntries, row: indexPath.row, cell: cell)
            
            let leftDate = dateformatter.string(from: leftEntries[indexPath.row].dateCreated!)
            let rightDate=dateformatter.string(from: rightEntries[indexPath.row].dateCreated!)
            
            cell.dateLabel.text = ("\(leftDate)\n\(rightDate)")
            
            cell.rightDate=dateformatter.string(for: rightEntries[indexPath.row].dateCreated)
            cell.rightDidWell=rightEntries[indexPath.row].didWell!
            cell.rightGrateful=rightEntries[indexPath.row].gratefulThing!
            cell.rightJoyful=rightEntries[indexPath.row].funny
        }
        
        setLeftSide()
        
        if dayHighlightsArray.count%2 != 0{
            print("count is odd")
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
                
                if cell.rightZoom != nil{
                    cell.rightZoom.removeFromSuperview()
                }

                let leftDate = dateformatter.string(from: leftEntries[indexPath.row].dateCreated!)
                cell.dateLabel.text = ("\(leftDate)")
            }else{
                setRightSide()
            }
        }else{
            setRightSide()
        }

       return cell
    }
}

extension UIImageView {
    func setImageColor() {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage

        var myTempColors=[
            [UIColor(rgb: 0xef4b4b), UIColor(rgb: 0xec8f6a), UIColor(rgb: 0xf2e3c9), UIColor(rgb: 0x7ecfc0), UIColor(rgb: 0xf9e090),  UIColor(rgb: 0xedaaaa), UIColor(rgb: 0x9cf196), UIColor(rgb: 0xffdcf7), UIColor(rgb: 0xfce2ae), UIColor(rgb: 0xb6ffea), UIColor(rgb: 0x8bbabb)],
            
            [UIColor(rgb: 0x293462), UIColor(rgb: 0x216583), UIColor(rgb: 0xa72461), UIColor(rgb: 0x00818a), UIColor(rgb: 0x843b62), UIColor(rgb: 0x00a79d), UIColor(rgb: 0xcf455c), UIColor(rgb: 0x2d3561),  UIColor(rgb: 0x241663), UIColor(rgb: 0x226b80), UIColor(rgb: 0xdc5353), UIColor(rgb: 0x00818a)]
        ]

        
        let randomInt1 = Int.random(in: 0..<2)
        let randomInt2 = Int.random(in: 0..<myTempColors[randomInt1].count)
        self.tintColor = myTempColors[randomInt1][randomInt2]
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
