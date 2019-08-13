//
//  GameCell.swift
//  DayLights
//
//  Created by Audrey Ha on 8/11/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var gameButton: UIButton!
    var count=0
    
    @IBAction func gameButtonPressed(_ sender: Any) {
        count+=1
        var countLabelText=Int(countLabel.text!)
        
        if (countLabelText==1){
            getIndexPath()
             NotificationCenter.default.post(name: Notification.Name("finishedCount"), object: nil)
        }else{
            countLabel.text="\(countLabelText!-1)"
        }
    }
    
    func getIndexPath(){
        if let superView = self.superview as? UICollectionView{
            var myIndexPath = superView.indexPath(for: self)
            UserDefaults.standard.set(myIndexPath!.row, forKey: "rowOfFinishedCount")
        }
    }
}
