//
//  ContainerVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/26/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import Foundation

import UIKit

class ContainerVC: UIViewController{
    
    @IBOutlet weak var hamburgerConstraint: NSLayoutConstraint!
    var sideMenuOpen=false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        hideSideMenu()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func toggleSideMenu(){
        if (sideMenuOpen==true){ //closing
            sideMenuOpen=false
            print("reached here")
            hamburgerConstraint.constant = -240
        }else{ //opening
            sideMenuOpen=true
            print("reached 2")
            hamburgerConstraint.constant = 0
        }
    }
    
    func hideSideMenu() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissSideMenu() { //closing
        sideMenuOpen=false
        print("reached 3")
        hamburgerConstraint.constant = -240
    }
    
}
