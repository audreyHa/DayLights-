//
//  DidWellTableViewCell.swift
//  DayLights
//
//  Created by Audrey Ha on 3/27/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class DidWellTableViewCell: UITableViewCell {

    @IBOutlet weak var didWellDate: UILabel!
    @IBOutlet weak var didWellText: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
