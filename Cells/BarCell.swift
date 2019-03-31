//
//  File.swift
//  DayLights
//
//  Created by Audrey Ha on 3/29/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import Foundation
import UIKit

class BarCell: UICollectionViewCell{
    
    
    let barView: UIView = {
        let view=UIView()

        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    
    let lowerBar: UIView = {
        let view=UIView()
        
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    
    let barDate: UILabel = {
        let label=UILabel()
        label.text="This"
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    var barHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(barView)
        barHeightConstraint=barView.heightAnchor.constraint(equalToConstant: 300)
        barHeightConstraint?.isActive=true

        barView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        barView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        barView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        barView.addSubview(barDate)
        
//        addSubview(lowerBar)
//        lowerBar.heightAnchor.constraint(equalToConstant: 100).isActive=true
//
//        lowerBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        lowerBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        lowerBar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        lowerBar.backgroundColor=UIColor.blue
        
//        addSubview(barDate)
//        barDate.heightAnchor.constraint(equalToConstant: 30).isActive=true
//        barDate.widthAnchor.constraint(equalToConstant: 30).isActive=true
//        barDate.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
//        barDate.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
//        barDate.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

