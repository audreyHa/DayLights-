//
//  SpeechAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 9/10/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class SpeechAlert: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var speechTextView: UITextView!
    @IBOutlet weak var speechDateLabel: UILabel!
    
    var speech: Speech?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechTextView.layer.cornerRadius=5
        
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
        
        if speech != nil{
            titleTextField.text=speech!.title!
            speechTextView.text=speech!.speech!
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yy"
            let reformattedDate=dateformatter.string(from: speech!.dateModified!)
            
            speechDateLabel.text=reformattedDate
        }else{
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yy"
            let reformattedDate=dateformatter.string(from: Date())
            
            speechDateLabel.text=reformattedDate
        }
        
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        if (speechTextView.text != ""){
            if speech==nil{ //if creating completely new speech
                var newSpeech=CoreDataHelper.newSpeech()
                
                if(titleTextField.text != ""){
                    newSpeech.title=titleTextField.text!
                }else{
                    newSpeech.title="Untitled Speech"
                }
                
                newSpeech.speech=speechTextView.text
                newSpeech.dateModified=Date()
                
                CoreDataHelper.saveDaylight()
            }else{
                if(titleTextField.text != ""){
                    speech!.title=titleTextField.text!
                }else{
                    speech!.title="Untitled Speech"
                }
                
                speech!.speech=speechTextView.text
                speech!.dateModified=Date()
                
                CoreDataHelper.saveDaylight()
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name("reloadSpeechTableView"), object: nil)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
