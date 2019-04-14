//
//  ShowAllCell.swift
//  DayLights
//
//  Created by Audrey Ha on 4/13/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class ShowAllCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var didWellText: UILabel!
    @IBOutlet weak var gratefulText: UILabel!
    @IBOutlet weak var joyText: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
