//
//  ViewController.swift
//  DayLights
//
//  Created by Audrey Ha on 3/25/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var didWellText: UITextView!
    @IBOutlet weak var gratefulText: UITextView!
    
    
    @IBAction func onMoreTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("OpenSideMenu"), object: nil)
    }
    
    @IBAction func saveDayLights(_ sender: UIButton) {
        var daylightsArray=[Daylight]()
        daylightsArray=CoreDataHelper.retrieveDaylight()
        var count=0;
        for value in daylightsArray{
            print("hello")
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yy"
            let now = dateformatter.string(from: Date())
            let reformatedPastDate=dateformatter.string(from: value.dateCreated!)
            
            if (now==reformatedPastDate){
                count+=1
            }
        }
        
        if (count==0){
            var daylight=CoreDataHelper.newDaylight()
            if (didWellText.text==""){
                daylight.didWell="None entered"
            }else{
                daylight.didWell=didWellText.text!
            }
            
            if (gratefulText.text==""){
                daylight.gratefulThing="None entered"
            }else{
                daylight.gratefulThing=gratefulText.text!
            }
            
            daylight.dateCreated=Date()
            CoreDataHelper.saveDaylight()
        }else{
            createAlert(title: "ALERT!", message: "You have already created DayLights for today! See you tomorrow!")
            count=0;
        }
        
        didWellText.text = ""
        gratefulText.text = ""
    }
    
    func createAlert(title: String, message: String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDidWell), name: NSNotification.Name("DidWell"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showGratefulThings), name: NSNotification.Name("GratefulThings"), object: nil)
        self.hideSide()
        self.hideKeyboardWhenTappedAround() 
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let now = dateformatter.string(from: Date())
        
        dateLabel.text=now
        // Do any additional setup after loading the view, typically from a nib.
    }//end of view did load
    
    @objc func showDidWell(){
        performSegue(withIdentifier: "showDidWell", sender: nil)
    }
    
    @objc func showGratefulThings(){
        performSegue(withIdentifier: "showGratefulThings", sender: nil)
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

extension UIViewController {
    func hideSide() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissMenu))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMenu() {
        NotificationCenter.default.post(name: NSNotification.Name("hideSide"), object: nil)
    }
}
