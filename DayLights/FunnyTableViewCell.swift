//
//  FunnyTableViewCell.swift
//  DayLights
//
//  Created by Audrey Ha on 3/28/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class FunnyTableViewCell: UITableViewCell {

    @IBOutlet weak var funnyDate: UILabel!
    @IBOutlet weak var funnyData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
