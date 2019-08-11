//
//  EntryAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 8/10/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class EntryAlert: ViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var bigHeader: UILabel!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigHeader.adjustsFontSizeToFitWidth = true
        label.adjustsFontSizeToFitWidth = true
        okButton.setTitle("  Ok  ", for: .normal)
        okButton.titleLabel!.adjustsFontSizeToFitWidth = true

        var myHeader=UserDefaults.standard.string(forKey: "bigHeader")
        var bodyText=UserDefaults.standard.string(forKey: "bodyText")
        var dateToInclude=UserDefaults.standard.string(forKey: "dateToInclude")
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let reformattedDate=dateformatter.date(from: dateToInclude!)
       
        bigHeader.text=dateToInclude
        label.text=bodyText
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        okButton.layer.cornerRadius = 5
        okButton.clipsToBounds = true
        
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
    }
    
    @IBAction func okPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        switch(UserDefaults.standard.string(forKey: "typeShortAlert")){
        case "fillFirst":
            NotificationCenter.default.post(name: Notification.Name("fillFirst"), object: nil, userInfo: nil)
        default:
            print("don't do anything")
        }
        
        dismiss(animated: true, completion: nil)
        
    }

}
