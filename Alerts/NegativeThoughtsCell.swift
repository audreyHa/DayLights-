//
//  NegativeThoughtsCell.swift
//  DayLights
//
//  Created by Audrey Ha on 8/11/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class NegativeThoughtsCell: UITableViewCell {

    @IBOutlet weak var thoughtLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var severeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
