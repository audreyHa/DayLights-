//
//  ControlPanelVC.swift
//  DayLights
//
//  Created by Audrey Ha on 9/16/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class ControlPanelVC: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var graphButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.adjustsFontSizeToFitWidth=true
        
        var buttons=[yesButton, galleryButton, graphButton, gameButton]
        
        for button in buttons{
            button!.titleLabel!.adjustsFontSizeToFitWidth = true
            
            button!.layer.cornerRadius = 5
            button!.clipsToBounds = true
        }
        
        instructionsLabel.adjustsFontSizeToFitWidth=true
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true

        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
        
        
    }
    
    @IBAction func galleryPressed(_ sender: Any) {
         NotificationCenter.default.post(name: NSNotification.Name("showDidWell"), object: nil)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func graphPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowMood"), object: nil)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gamePressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("stressGames"), object: nil)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
