//
//  side.swift
//  DayLights
//
//  Created by Audrey Ha on 3/26/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class Side: UIViewController {

    @IBOutlet weak var createNewButton: UIButton!
    @IBOutlet weak var galleriesButton: UIButton!
    @IBOutlet weak var moodTrackerButton: UIButton!
    @IBOutlet weak var stressGames: UIButton!
    @IBOutlet weak var resourcesHotlinesButton: UIButton!
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("searchDayLights"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenu"), object: nil)
        
    }
    
    @IBAction func resourcesPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("resources"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenu"), object: nil)
    }
    
    @IBAction func didWellPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("showDidWell"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenu"), object: nil)
        
    }

    @IBAction func moodTrackerPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowMood"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenu"), object: nil)

    }
    
    @IBAction func stressGamesPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("stressReliefControlVC"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenu"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttons=[createNewButton, galleriesButton, moodTrackerButton, stressGames, resourcesHotlinesButton]
        for button in buttons{
            button!.titleLabel?.adjustsFontSizeToFitWidth=true
        }

    }

    
}
