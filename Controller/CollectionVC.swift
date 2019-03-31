//
//  CollectionVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/30/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import Foundation
import UIKit

class CollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let cellId="cellId"
    var values=[Int]()
    var daylightsArray=[Daylight]()
    var red1=UIColor(red: 255.0/255.0, green: 124.0/255.0, blue: 124.0/255.0, alpha: 1.0)
    var orange2=UIColor(red: 253.0/255.0, green: 171.0/255.0, blue: 36.0/255.0, alpha: 1.0)
    var yellow3=UIColor(red: 255.0/255.0, green: 202.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    var blue4=UIColor(red: 126.0/255.0, green: 227.0/255.0, blue: 219.0/255.0, alpha: 1.0)
    var green5 = UIColor(red: 117.0/255.0, green: 214.0/255.0, blue: 161.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daylightsArray=CoreDataHelper.retrieveDaylight()
        for value in daylightsArray{
            if (value.mood != 0){
                values.append(Int(value.mood*120))
            }
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
        if (values[indexPath.item]==120){
            cell.barView.backgroundColor=red1
        }else if (values[indexPath.item]==2*120){
            cell.barView.backgroundColor=orange2
        }else if (values[indexPath.item]==3*120){
            cell.barView.backgroundColor=yellow3
        }else if (values[indexPath.item]==4*120){
            cell.barView.backgroundColor=blue4
        }else if (values[indexPath.item]==5*120){
            cell.barView.backgroundColor=green5
        }else{
            cell.barView.backgroundColor=UIColor.blue
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: view.frame.height)
    }
}
