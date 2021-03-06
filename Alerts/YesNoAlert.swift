//
//  YesNoAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 8/11/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class YesNoAlert: UIViewController{
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var myDayhighlights=CoreDataHelper.retrieveDaylight()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yesButton.titleLabel!.adjustsFontSizeToFitWidth = true
        noButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        yesButton.layer.cornerRadius = 5
        yesButton.clipsToBounds = true
        
        noButton.layer.cornerRadius = 5
        noButton.clipsToBounds = true

        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
        
        headerLabel.adjustsFontSizeToFitWidth=true
        bodyText.adjustsFontSizeToFitWidth=true
        
        switch (UserDefaults.standard.string(forKey: "typeYesNoAlert")) {
        case "delete":
            headerLabel.text="Confirm!"
            bodyText.text="Are you sure you want to delete this entry? You cannot undo this action."
        case "deleteFunnyImage":
            headerLabel.text="Confirm!"
            bodyText.text="Are you sure you want to delete this image? You cannot undo this action."
        case "deleteDrawing":
            headerLabel.text="Confirm!"
            bodyText.text="Are you sure you want to delete this drawing? You cannot undo this action."
        case "deleteSpeech":
            headerLabel.text="Confirm!"
            bodyText.text="Are you sure you want to delete this motivational speech? You cannot undo this action."
        case "deleteContact":
            headerLabel.text="Confirm!"
            bodyText.text="Are you sure you want to delete this contact?"
        default:
            print("Error! Could not react to yes no alert!")
        }
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        switch (UserDefaults.standard.string(forKey: "typeYesNoAlert")) {
        case "delete":
            NotificationCenter.default.post(name: Notification.Name("delete"), object: nil)
        case "deleteSpeech":
            NotificationCenter.default.post(name: Notification.Name("permanentlyDeleteSpeech"), object: nil)
        case "deleteContact":
            NotificationCenter.default.post(name: Notification.Name("permanentlyDeleteContact"), object: nil)
        default:
            NotificationCenter.default.post(name: Notification.Name("permanentlyDeleteImage"), object: nil)
        }
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
}
