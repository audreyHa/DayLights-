//
//  contactCell.swift
//  DayLights
//
//  Created by Audrey Ha on 9/15/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Firebase

class contactCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var mediumBlue: UIColor!
    var navyBlue: UIColor!
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if addButton.titleLabel!.text=="Add"{
            Analytics.logEvent("addedContact", parameters: nil)
            
            var newContact=CoreDataHelper.newContact()
            newContact.name=nameLabel.text
            newContact.phoneNumber=phoneNumberLabel.text
            CoreDataHelper.saveDaylight()
            
            addButton.titleLabel?.textColor=UIColor.white
            addButton.backgroundColor=navyBlue
            addButton.setTitle(" Added ", for: .normal)
        }else{
            var allContacts=CoreDataHelper.retrieveContacts()
            
            for contact in allContacts{
                if contact.phoneNumber==phoneNumberLabel.text!{
                    CoreDataHelper.delete(contact: contact)
                }
            }
            
            addButton.titleLabel?.textColor=UIColor.black
            addButton.backgroundColor=mediumBlue
            addButton.setTitle("Add", for: .normal)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mediumBlue=UIColor(rgb: 0x1fc2ff)
        navyBlue=UIColor(rgb: 0x285C95)
        
        addButton.layer.cornerRadius=5
        addButton.titleLabel?.adjustsFontSizeToFitWidth=true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
