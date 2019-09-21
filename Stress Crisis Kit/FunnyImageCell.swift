//
//  FunnyImageCell.swift
//  DayLights
//
//  Created by Audrey Ha on 9/10/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class FunnyImageCell: UICollectionViewCell {
    
    @IBOutlet weak var funnyImageView: UIImageView!
    @IBOutlet weak var deleteImageButton: UIButton!
    
    @IBAction func deleteImage(_ sender: Any) {
        guard let superView = self.superview as? UICollectionView else {return}

        var myIndexPath = superView.indexPath(for: self)
        UserDefaults.standard.set(myIndexPath!.row, forKey: "possiblyDeleteImageRow")
        
        NotificationCenter.default.post(name: Notification.Name("possiblyDeleteImage"), object: nil)
    }
    
    
}
