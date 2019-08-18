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

    
    @IBAction func gameButtonPressed(_ sender: Any) {

        var tempInt=Int(countLabel.text!)
        countLabel.text="\(tempInt!-1)"
        
        var coreDataArray=CoreDataHelper.retrieveNegativeThought()
        var indexPath=returnIndexPath()
        coreDataArray[indexPath.row].sliderValue=Int64(countLabel.text!)!
        CoreDataHelper.saveDaylight()
        
        if (tempInt==1){
            getIndexPath()
             NotificationCenter.default.post(name: Notification.Name("finishedCount"), object: nil)
        }

    }
    
    func getIndexPath(){
        if let superView = self.superview as? UICollectionView{
            var myIndexPath = superView.indexPath(for: self)
            UserDefaults.standard.set(myIndexPath!.row, forKey: "rowOfFinishedCount")
        }
    }
    
    func returnIndexPath() -> IndexPath{
        var myIndexPath: IndexPath!
        if let superView = self.superview as? UICollectionView{
            myIndexPath = superView.indexPath(for: self)
        }
        
        return myIndexPath!
    }

}
