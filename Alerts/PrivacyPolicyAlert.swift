//
//  PrivacyPolicyAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 8/17/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class PrivacyPolicyAlert: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yesButton.titleLabel!.adjustsFontSizeToFitWidth = true
        bodyText.adjustsFontSizeToFitWidth=true
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        yesButton.layer.cornerRadius = 5
        yesButton.clipsToBounds = true
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
        headerLabel.adjustsFontSizeToFitWidth=true
        headerLabel.text="Privacy Policy!"
        bodyText.text="By clicking “Continue” or continuing to use this app, you acknowledge that DayHighlights incorporates an analytical tool (Answers) tracking how many times users land on different screens to improve user experience and guide development for future features. Any identifiable information (name, contact information, location, etc.) will not be collected. Your DayHighLights are stored locally on your phone; no third party (including me) has access to your content in this app. If you have any questions, please contact DayHighlightsApp@gmail.com!"
        yesButton.setTitle("Continue", for: .normal)
        
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        if let settings = UIApplication.shared.currentUserNotificationSettings {
            if settings.types.contains([.alert, .sound]) {
                //Have alert and sound permissions
                NotificationCenter.default.post(name: Notification.Name("notiTime"), object: nil)
            } else if settings.types.contains(.alert) {
                //Have alert permission
                NotificationCenter.default.post(name: Notification.Name("notiTime"), object: nil)
            }else{
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
