//
//  StressfulCell.swift
//  DayLights
//
//  Created by Audrey Ha on 8/22/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class StressfulCell: UICollectionViewCell {
    @IBOutlet weak var leftHandImage: UIImageView!
    @IBOutlet weak var rightHandImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var leftZoom: UIButton!
    @IBOutlet weak var rightZoom: UIButton!
    
    var leftDate: String!
    var leftDidWell: String!
    var leftGrateful: String!
    var leftJoyful: String!
    
    var rightDate: String!
    var rightDidWell: String!
    var rightGrateful: String!
    var rightJoyful: String!
    
    @IBAction func onLeftZoomTouched(_ sender: Any) {
        UserDefaults.standard.set("left", forKey: "sideInCell")
        UserDefaults.standard.set(leftDidWell,forKey: "didWellText")
        UserDefaults.standard.set(leftGrateful,forKey: "gratefulText")
        UserDefaults.standard.set(leftJoyful, forKey: "joyfulText")
        UserDefaults.standard.set(leftDate, forKey: "dateToInclude")
        getIndexPath()
        NotificationCenter.default.post(name: Notification.Name("showEntryAlert"), object: nil)
        
    }
    
    @IBAction func onRightZoomTouched(_ sender: Any) {
        UserDefaults.standard.set("right", forKey: "sideInCell")
        UserDefaults.standard.set(rightDidWell,forKey: "didWellText")
        UserDefaults.standard.set(rightGrateful,forKey: "gratefulText")
        UserDefaults.standard.set(rightJoyful, forKey: "joyfulText")
        UserDefaults.standard.set(rightDate, forKey: "dateToInclude")
        getIndexPath()
        NotificationCenter.default.post(name: Notification.Name("showEntryAlert"), object: nil)
        
    }
    
    func getIndexPath(){
        if let superView = self.superview as? UICollectionView{
            var myIndexPath = superView.indexPath(for: self)
            UserDefaults.standard.set(myIndexPath!.row, forKey: "rowOfPressedZoom")
        }
    }
}
