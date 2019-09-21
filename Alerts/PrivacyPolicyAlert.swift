//
//  PrivacyPolicyAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 8/17/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Firebase

class PrivacyPolicyAlert: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyText: UITextView!
    @IBOutlet weak var yesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yesButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
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
        bodyText.text="By clicking continue or continuing to use this app, you acknowledge that:\n\nDayHighlights incorporates Google Analytics for Firebase or Firebase Analytics: an analytics service provided by Google LLC. In order to understand Google's use of Data, see Google's policy on “How Google uses data when you use our partners' sites or apps.”\n\nFirebase Analytics may share Data with other tools provided by Firebase, such as Crash Reporting, Authentication, Remote Config or Notifications.\n\nPersonal Data collected by DayHighlights through Firebase:\n\u{2022}Geography/region\n\u{2022}Number of users\n\u{2022}Number of sessions\n\u{2022}Session duration\n\u{2022}iPhone type\n\u{2022}Application opens\n\u{2022}Application updates\n\u{2022}First launches\n\u{2022}How often users land on different pages or do certain events (saving entries, deleting entries, etc.) \n\u{2022}Frequency of app crashes\n\nThe only purpose of DayHighlights collecting user behavior data for this version is to improve user experience and guide development for the next release. If you do not wish to participate and help the app (and me) better understand your needs, you are always welcome to come back and install a later version.\n\nAll of your entries are stored locally on your phone. No third party (including me!) accesses the entries you store in this app.\n\nIf you have any questions, please feel free to contact me at dayhighlightsapp@gmail.com!"
        
        let linkedText = NSMutableAttributedString(attributedString: bodyText.attributedText!)
        let hyperlinked = linkedText.setAsLink(textToFind: "“How Google uses data when you use our partners' sites or apps.”", linkURL: "https://policies.google.com/technologies/partner-sites")
        
        if hyperlinked {
            bodyText.attributedText! = NSAttributedString(attributedString: linkedText)
        }
        
        yesButton.setTitle("Continue", for: .normal)
        
    }
    
    @IBAction func yesPressed(_ sender: Any) {
         Analytics.logEvent("acceptedPrivacyPolicy", parameters: nil)
        
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
