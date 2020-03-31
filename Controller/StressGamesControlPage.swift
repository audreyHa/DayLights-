//
//  StressGamesControlPage.swift
//  DayLights
//
//  Created by Audrey Ha on 9/4/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class StressGamesControlPage: UIViewController {

    @IBOutlet weak var stressReliefTitle: UILabel!
    @IBOutlet weak var balloonPoppingGame: UIButton!
    @IBOutlet weak var balloonDraggingGame: UIButton!
    @IBOutlet weak var randomDrawing: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stressReliefTitle.adjustsFontSizeToFitWidth=true
        
        var buttons=[balloonPoppingGame, balloonDraggingGame, randomDrawing]
        
        for button in buttons{
            button!.layer.cornerRadius=10
            button!.titleLabel?.adjustsFontSizeToFitWidth=true
        }
        
        // Do any additional setup after loading the view.
    }
}
