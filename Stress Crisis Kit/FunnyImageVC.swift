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
    
    @IBOutlet weak var headerLabel: UILabel!
    
    var funnyImages=[FunnyImage]()
    var drawings=[Drawing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if headerLabel.text == "My Drawings!"{
            drawings=CoreDataHelper.retrieveDrawing()
        }else{
            funnyImages=CoreDataHelper.retrieveFunnyImage()
        }
        
        funnyCollectionView.delegate=self
        funnyCollectionView.dataSource=self
        
        var layout=funnyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset=UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        layout.minimumInteritemSpacing=0
        layout.itemSize=CGSize(width: (funnyCollectionView.frame.size.width - 15), height: (funnyCollectionView.frame.size.width - 15))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if headerLabel.text=="Funny Images Gallery!"{
            var intIndex=UserDefaults.standard.integer(forKey: "indexPathToScrollTo")
            var indexPathToScrollTo=IndexPath(item: intIndex, section: 0)
            funnyCollectionView.scrollToItem(at: indexPathToScrollTo, at: .top, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if headerLabel.text == "My Drawings!"{
            return drawings.count
        }else{
            print("Funny images count \(funnyImages.count)")
            return funnyImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=funnyCollectionView.dequeueReusableCell(withReuseIdentifier: "FunnyImageCell", for: indexPath) as! FunnyImageCell
        
        var filename: String!
        
        if headerLabel.text == "My Drawings!"{
            filename=drawings[indexPath.row].filename
        }else{
            filename=funnyImages[indexPath.row].imageFilename
        }
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(filename!)
            let funnyImage = UIImage(contentsOfFile: imageURL.path)
            var copyToCrop=funnyImage
            
            let imageWidth = copyToCrop!.size.width
            let imageHeight = copyToCrop!.size.height
            var smallerValue = imageWidth
            
            if imageHeight<imageWidth{
                smallerValue=imageHeight
            }
            
            let origin = CGPoint(x: (imageWidth - smallerValue)/2, y: (imageHeight - smallerValue)/2)
            let size = CGSize(width: smallerValue, height: smallerValue)
            
            copyToCrop=copyToCrop!.crop(rect: CGRect(origin: origin, size: size))
            
            cell.funnyImageView.image=copyToCrop
            
            cell.funnyImageView.frame=cell.bounds
            
            cell.funnyImageView.layer.cornerRadius=10
            
            if headerLabel.text == "My Drawings!"{
                //add label with the prompt
                for subview in cell.funnyImageView.subviews{
                    if let item = subview as? UILabel{
                        item.removeFromSuperview()
                    }
                }
                
                var label = UILabel(frame: CGRect(x: cell.funnyImageView.frame.width/2, y: 0, width: cell.funnyImageView.frame.width/2, height: 60))
                label.textAlignment = NSTextAlignment.right
                label.text = drawings[indexPath.row].prompt!
                
                label.adjustsFontSizeToFitWidth=true
                label.numberOfLines=100
                label.font=UIFont(name: "Avenir", size: 20)
                label.textColor=UIColor.black
                label.backgroundColor=UIColor(red: 1, green: 1, blue: 1, alpha:0.5)
                
                cell.funnyImageView.addSubview(label)
            }
        }
        
        return cell
    }

}
