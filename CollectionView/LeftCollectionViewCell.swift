//
//  LeftCollectionViewCell.swift
//  DayLights
//
//  Created by Audrey Ha on 8/9/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class LeftCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var leftHandImage: UIImageView!
    @IBOutlet weak var rightHandImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var leftZoom: UIButton!
    @IBOutlet weak var rightZoom: UIButton!
    
    var leftDate: String!
    var leftEntry: String!
    var leftType: String!
    
    var rightDate: String!
    var rightEntry: String!
    var rightType: String!
    
    @IBAction func onLeftZoomTouched(_ sender: Any) {
        UserDefaults.standard.set(leftType,forKey: "bigHeader")
        UserDefaults.standard.set(leftEntry,forKey: "bodyText")
        UserDefaults.standard.set(leftDate,forKey: "dateToInclude")
        UserDefaults.standard.set("leftEntryAlert", forKey: "typeEntryAlert")
        
        NotificationCenter.default.post(name: Notification.Name("showEntryAlert"), object: nil)
    }
    

}
