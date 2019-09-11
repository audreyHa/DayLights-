//
//  FunnyImageVC.swift
//  DayLights
//
//  Created by Audrey Ha on 9/10/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class FunnyImageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var funnyCollectionView: UICollectionView!
    var funnyImages=[FunnyImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        funnyImages=CoreDataHelper.retrieveFunnyImage()
        funnyCollectionView.delegate=self
        funnyCollectionView.dataSource=self
        
        var layout=funnyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset=UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        layout.minimumInteritemSpacing=0
        layout.itemSize=CGSize(width: (funnyCollectionView.frame.size.width - 20)/2, height: (funnyCollectionView.frame.size.height)/3)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Funny images count \(funnyImages.count)")
        return funnyImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=funnyCollectionView.dequeueReusableCell(withReuseIdentifier: "FunnyImageCell", for: indexPath) as! FunnyImageCell
        
        var filename=funnyImages[indexPath.row].imageFilename
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(filename!)
            let funnyImage = UIImage(contentsOfFile: imageURL.path)
            
            cell.funnyImageView.image=funnyImage
        }
        
        return cell
    }

}
