//
//  CollectionVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/30/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class CollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    var daylightsArray=[Daylight](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    let cellId="cellId"
    var values=[Int]()

    var red1=UIColor(red: 255/255.0, green: 70/255.0, blue: 67/255.0, alpha: 1.0)
    var orange2=UIColor(red: 255/255.0, green: 135/255.0, blue: 32/255.0, alpha: 1.0)
    var yellow3=UIColor(red: 255/255.0, green: 236/255.0, blue: 116/255.0, alpha: 1.0)
    var blue4=UIColor(red: 103/255.0, green: 255/255.0, blue: 134/255.0, alpha: 1.0)
    var green5=UIColor(red: 41/255.0, green: 220/255.0, blue: 255/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEvent(withName: "Opened Mood Graph Page", customAttributes: nil)
        daylightsArray=CoreDataHelper.retrieveDaylight()
        daylightsArray = daylightsArray.sorted(by: { $1.dateCreated!.compare($0.dateCreated!) == .orderedDescending })
        for value in daylightsArray{
            if (value.mood != 0){
                values.append(Int(value.mood*100))
            }
        }
        print(values)
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
        
        
        if (values[indexPath.item]==120){
            cell.barView.backgroundColor=red1
        }else if (values[indexPath.item]==2*100){
            cell.barView.backgroundColor=orange2
        }else if (values[indexPath.item]==3*100){
            cell.barView.backgroundColor=yellow3
        }else if (values[indexPath.item]==4*100){
            cell.barView.backgroundColor=blue4
        }else if (values[indexPath.item]==5*100){
            cell.barView.backgroundColor=green5
        }else{
            cell.barView.backgroundColor=blue4
        }
        
        var editedDaylightsArray=[Daylight]()
        for daylight in daylightsArray{
            if (daylight.mood==0){
                print("we are not adding this to the edited list!!!")
            }else{
                editedDaylightsArray.append(daylight)
            }
        }
        
        editedDaylightsArray=editedDaylightsArray.sorted(by: { $1.dateCreated!.compare($0.dateCreated!) == .orderedDescending })
        var date=editedDaylightsArray[indexPath.item].dateCreated!
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd"
        let now = dateformatter.string(from: date)
    
        cell.barDate.text="\(now)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: view.frame.height)
    }
}
