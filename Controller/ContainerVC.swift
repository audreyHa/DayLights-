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
        hideTheSide()
        hideSideMenu()
        NotificationCenter.default.addObserver(self, selector: #selector(openSideMenu), name: NSNotification.Name("OpenSideMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeSideMenu), name: NSNotification.Name("CloseSideMenu"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(hideSideMenu), name: NSNotification.Name("hideSide"), object: nil)
    }
    
    @objc func openSideMenu(){
        print("opened")
        hamburgerConstraint.constant = 0
    }
    
    @objc func closeSideMenu(){
        print("closed")
        hamburgerConstraint.constant = -240
    }
    
    
    //after touching outside
    @objc func hideSideMenu() {
        sideMenuOpen=false
        hamburgerConstraint.constant = -240
    }
    
    //after touching menu
    func hideTheSide() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTheMenu))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissTheMenu() {
        NotificationCenter.default.post(name: NSNotification.Name("hideSide"), object: nil)
        sideMenuOpen=false
        hamburgerConstraint.constant = -240
    }
    
}

