//
//  NegativeThoughtsGame.swift
//  DayLights
//
//  Created by Audrey Ha on 8/11/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class NegativeThoughtsGame: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var negativeThoughtsArray=[NegativeThought]()
    var myColors=[[UIColor]]()
    var allCells=[GameCell]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource=self
        collectionView.delegate=self
        
        negativeThoughtsArray=CoreDataHelper.retrieveNegativeThought()
        
        var layout=self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize=CGSize(width: (self.collectionView.frame.size.width-20)/2, height:(self.collectionView.frame.size.height-20)/3)
        layout.sectionInset = UIEdgeInsets(top: 5,left: 10,bottom: 5,right: 5)
        layout.minimumInteritemSpacing=5
        
        myColors=[
            //light
            [UIColor(rgb: 0xef4b4b), UIColor(rgb: 0xec8f6a), UIColor(rgb: 0xf2e3c9), UIColor(rgb: 0x7ecfc0), UIColor(rgb: 0xf9e090),  UIColor(rgb: 0xedaaaa), UIColor(rgb: 0x9cf196), UIColor(rgb: 0xffdcf7), UIColor(rgb: 0xfce2ae), UIColor(rgb: 0xb6ffea), UIColor(rgb: 0x8bbabb)],
            
            //dark
            [UIColor(rgb: 0x293462), UIColor(rgb: 0x216583), UIColor(rgb: 0xa72461), UIColor(rgb: 0x00818a), UIColor(rgb: 0x843b62), UIColor(rgb: 0x00a79d), UIColor(rgb: 0xcf455c), UIColor(rgb: 0x2d3561),  UIColor(rgb: 0x241663), UIColor(rgb: 0x226b80), UIColor(rgb: 0xdc5353), UIColor(rgb: 0x00818a), UIColor(rgb: 0x207561), UIColor(rgb: 0x366ed8), UIColor(rgb: 0x843b62), UIColor(rgb: 0x553c8b)]
        ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.retrieveNegativeThoughts(notification:)), name: Notification.Name("retrieveNegativeThoughts"), object: nil)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedCount(notification:)), name: Notification.Name("finishedCount"), object: nil)
    }
    
    @objc func finishedCount(notification: Notification) {
        print("finished count")

        var myIndexRow=UserDefaults.standard.integer(forKey: "rowOfFinishedCount")

        var negativeThoughtToDelete=negativeThoughtsArray[myIndexRow]
        CoreDataHelper.delete(negativeThought: negativeThoughtToDelete)
                
        negativeThoughtsArray=CoreDataHelper.retrieveNegativeThought()
                
        collectionView.reloadData()
    }
    
    @objc func appMovedToBackground() {
        for negativeThought in negativeThoughtsArray{
            CoreDataHelper.delete(negativeThought: negativeThought)
        }
        
        negativeThoughtsArray=[]
        
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for negativeThought in negativeThoughtsArray{
            CoreDataHelper.delete(negativeThought: negativeThought)
        }
        negativeThoughtsArray=[]
        collectionView.reloadData()
    }
    
    @objc func retrieveNegativeThoughts(notification: Notification) {
        print("received notification")
        negativeThoughtsArray=CoreDataHelper.retrieveNegativeThought()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "NegativeThoughtsEntering") as! NegativeThoughtsEntering
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return negativeThoughtsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        
        if negativeThoughtsArray.count>0{
            var multipliedCount=negativeThoughtsArray[indexPath.row].sliderValue*1
            
            if cell.countLabel.text == ""{
                print("putting number onto count label")
                cell.countLabel.text="\(multipliedCount)"
            }else{
                print("not putting number onto count label")
            }

            for subview in cell.gameButton.subviews{
                if let item = subview as? UIImageView{
                    item.removeFromSuperview()
                }
            }
            
            var myImageView=UIImageView()
            myImageView.frame=CGRect(x: 0, y: 0, width: cell.gameButton.frame.width, height: cell.gameButton.frame.height)
            myImageView.image = UIImage(imageLiteralResourceName: "greenBalloon").withRenderingMode(.alwaysTemplate)
            myImageView.setImageColor()
            myImageView.center = CGPoint(x: cell.gameButton.frame.size.width  / 2,
                                         y: cell.gameButton.frame.size.height / 2)

            
            cell.gameButton.addSubview(myImageView)
            myImageView.bindFrameToSuperviewBounds()
            
            
            addLabel(button: cell.gameButton, myText: negativeThoughtsArray[indexPath.row].entry!)
        }
        
        if allCells.contains(cell){
            print("this cell is already there")
        }else{
            allCells.append(cell)
        }
        
        return cell
    }
    
    func addLabel(button: UIButton, myText: String){
        for subview in button.subviews{
            if let item = subview as? UILabel{
                item.removeFromSuperview()
            }
        }
        
        var label = UILabel(frame: CGRect(x: button.frame.width*0.17, y: button.frame.height*0.14, width: button.frame.width*0.53, height: button.frame.height*0.45))
        
        label.textAlignment = NSTextAlignment.left
        
        label.adjustsFontSizeToFitWidth=true
        label.numberOfLines=100
        label.font=UIFont(name: "Avenir", size: 17)
        
        label.text=myText
        if myColors[1].contains(button.tintColor){
            label.textColor=UIColor.white
        }else{
            label.textColor=UIColor.black
        }

        button.addSubview(label)
    }
}

extension UIImageView {
    func setImageColor() {
        var myTempColors=[UIColor(rgb: 0x7ecfc0), UIColor(rgb: 0x9cf196), UIColor(rgb: 0xb6ffea), UIColor(rgb: 0x00818a), UIColor(rgb: 0x00a79d), UIColor(rgb: 0x226b80), UIColor(rgb: 0x00818a), UIColor(rgb: 0x8bbabb), UIColor(rgb: 0xa0cc78), UIColor(rgb: 0x9cf196), UIColor(rgb: 0x5edfff), UIColor(rgb: 0xb2fcff), UIColor(rgb: 0xe0f5b9), UIColor(rgb: 0xc6f1d6), UIColor(rgb: 0xdaf1f9), UIColor(rgb: 0x366ed8), UIColor(rgb: 0xef4b4b), UIColor(rgb: 0xec8f6a), UIColor(rgb: 0xf2e3c9), UIColor(rgb: 0xf9e090),  UIColor(rgb: 0xedaaaa), UIColor(rgb: 0xffdcf7), UIColor(rgb: 0xfce2ae), UIColor(rgb: 0xdc5353), UIColor(rgb: 0xcf455c), UIColor(rgb: 0xf67e7d)]

        let randomInt = Int.random(in: 0..<myTempColors.count)
        self.tintColor = myTempColors[randomInt]
    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
        
    }
    
}
