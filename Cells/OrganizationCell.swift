//
//  OrganizationCell.swift
//  DayLights
//
//  Created by Audrey Ha on 4/8/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class OrganizationCell: UITableViewCell {

    @IBOutlet weak var orgName: UILabel!
    @IBOutlet weak var orgDesc: UILabel!
    @IBOutlet weak var contact: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
