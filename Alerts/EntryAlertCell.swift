//
//  EntryAlertCell.swift
//  DayLights
//
//  Created by Audrey Ha on 8/10/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class EntryAlertCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
