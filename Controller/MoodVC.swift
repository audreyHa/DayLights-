//
//  MoodVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/29/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class MoodVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var daylightsArray=[Daylight]()
        daylightsArray=CoreDataHelper.retrieveDaylight()

    }

}


