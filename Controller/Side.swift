//
//  side.swift
//  DayLights
//
//  Created by Audrey Ha on 3/26/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class Side: UIViewController {

    @IBAction func didWellPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("DidWell"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenu"), object: nil)
        
    }
    
    @IBAction func gratefulThingsPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("GratefulThings"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenu"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
