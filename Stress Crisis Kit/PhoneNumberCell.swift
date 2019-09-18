//
//  PhoneNumberCell.swift
//  DayLights
//
//  Created by Audrey Ha on 9/15/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class PhoneNumberCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deletePressed(_ sender: Any) {
        guard let superView = self.superview as? UITableView else {return}
        var myIndexPath = superView.indexPath(for: self)
        UserDefaults.standard.set(myIndexPath!.row, forKey: "possiblyContactRow")
        
        NotificationCenter.default.post(name: Notification.Name("possiblyDeleteContact"), object: nil)
    }
    
    @IBAction func textPressed(_ sender: Any) {
        guard let superView = self.superview as? UITableView else {return}
        var myIndexPath = superView.indexPath(for: self)
        
        UserDefaults.standard.set(myIndexPath!.row, forKey: "phoneNumberToText")
        
        NotificationCenter.default.post(name: Notification.Name("textNumber"), object: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
