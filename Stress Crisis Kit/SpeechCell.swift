//
//  SpeechCell.swift
//  DayLights
//
//  Created by Audrey Ha on 9/10/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class SpeechCell: UITableViewCell {

    @IBOutlet weak var speechTitleLabel: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deletePressed(_ sender: Any) {
        
        guard let superView = self.superview as? UITableView else {return}
        
        var speeches=CoreDataHelper.retrieveSpeech()
        var myIndexPath = superView.indexPath(for: self)
        var speechToRemove=speeches[myIndexPath!.row]
        CoreDataHelper.delete(speech: speechToRemove)
        CoreDataHelper.saveDaylight()
        speeches=CoreDataHelper.retrieveSpeech()
        
        NotificationCenter.default.post(name: Notification.Name("reloadSpeechTableView"), object: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
