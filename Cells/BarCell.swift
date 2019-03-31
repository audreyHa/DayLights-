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
        
//        view.backgroundColor=UIColor(red: 155.0/255.0, green: 219.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    
    var barHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(barView)
        //        barView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        barHeightConstraint=barView.heightAnchor.constraint(equalToConstant: 300)
        barHeightConstraint?.isActive=true
        barHeightConstraint?.constant=100
        //        barView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        barView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        barView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        barView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

