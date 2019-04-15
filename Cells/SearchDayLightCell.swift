//
//  SearchDayLightCell.swift
//  DayLights
//
//  Created by Audrey Ha on 4/13/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class SearchDayLightCell: UITableViewCell {

    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var didWellText: UILabel!
    @IBOutlet weak var gratefulText: UILabel!
    @IBOutlet weak var joyousText: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var moodText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
