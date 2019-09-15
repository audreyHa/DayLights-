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
    @IBOutlet weak var wholeAlertViewHeightConstraint: NSLayoutConstraint!
    
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
        
        self.view.layoutIfNeeded()
        titleTextField.text="Martin Luther King Jr: \"What Is Your Life's Blueprint?\""
        
        if titleTextField.text=="Martin Luther King Jr: \"What Is Your Life's Blueprint?\""{
            titleTextField.isUserInteractionEnabled=false
            speechTextView.isEditable=false

            let newConstraint = wholeAlertViewHeightConstraint.constraintWithMultiplier(0.75)
            view.removeConstraint(wholeAlertViewHeightConstraint)
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            wholeAlertViewHeightConstraint = newConstraint
            
            self.view.layoutIfNeeded()
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

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
