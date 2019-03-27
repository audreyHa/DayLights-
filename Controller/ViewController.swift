//
//  ViewController.swift
//  DayLights
//
//  Created by Audrey Ha on 3/25/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func onMoreTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround() 
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MM/dd/yy"
        
        let now = dateformatter.string(from: Date())
        
        dateLabel.text=now
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//extension UIViewController {
//    func hideSideMenu() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissSideMenu))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func dismissSideMenu() {
//        ContainerVC.hamburgerConstraint.constant = -240
//    }
//}
