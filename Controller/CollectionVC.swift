//
//  CollectionVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/29/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import Foundation
import UIKit

class CollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let cellId="cellId"
    var values=[Int]()
    var daylightsArray=[Daylight]()
    override func viewDidLoad() {
        super.viewDidLoad()
        daylightsArray=CoreDataHelper.retrieveDaylight()
        for value in daylightsArray{
            values.append(Int(value.mood*100))
        }
        collectionView?.backgroundColor = .white
        
        collectionView?.register(BarCell.self, forCellWithReuseIdentifier: cellId)
        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BarCell
        cell.barHeightConstraint?.constant=CGFloat(values[indexPath.item])
        cell.backgroundColor = .white
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: view.frame.height)
    }
}
