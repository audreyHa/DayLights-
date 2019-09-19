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
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor=UIColor.black
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

