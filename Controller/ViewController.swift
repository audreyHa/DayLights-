//
//  ViewController.swift
//  DayLights
//
//  Created by Audrey Ha on 3/25/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var count=0
    var daylightsArray=[Daylight]()
    @IBOutlet weak var didWellText: UITextView!
    @IBOutlet weak var gratefulText: UITextView!
    @IBOutlet weak var funnyText: UITextView!
    
    
    @IBAction func onMoreTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("OpenSideMenu"), object: nil)
    }
    
    @IBAction func saveDayLights(_ sender: UIButton) {
        
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
            
            if (funnyText.text==""){
                daylight.funny="None entered"
            }else{
                daylight.funny=funnyText.text!
            }
            
            daylight.dateCreated=Date()
            CoreDataHelper.saveDaylight()
            didWellText.text = ""
            gratefulText.text = ""
        }else if(count==1){
            createAlert(title: "ALERT!", message: "You already created 1 DayLights today! Do you still want to save this one?")
            count=0
        }else{
            createAlert(title: "ALERT!", message: "You already created \(count) DayLights today! Do you still want to save this one?")
            count=0
        }
    }
    
    func createAlert(title: String, message: String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            var daylight=CoreDataHelper.newDaylight()
            if (self.didWellText.text==""){
                daylight.didWell="None entered"
            }else{
                daylight.didWell=self.didWellText.text!
            }
            
            if (self.gratefulText.text==""){
                daylight.gratefulThing="None entered"
            }else{
                daylight.gratefulThing=self.gratefulText.text!
            }
            
            if (self.funnyText.text==""){
                daylight.funny="None entered"
            }else{
                daylight.funny=self.funnyText.text!
            }
            
            daylight.dateCreated=Date()
            CoreDataHelper.saveDaylight()
            self.didWellText.text = ""
            self.gratefulText.text = ""
            self.funnyText.text=""

        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.didWellText.text = ""
            self.gratefulText.text = ""
            self.funnyText.text=""
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDidWell), name: NSNotification.Name("DidWell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGratefulThings), name: NSNotification.Name("GratefulThings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFunny), name: NSNotification.Name("FunnyThings"), object: nil)
        
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
    
    @objc func showFunny(){
        performSegue(withIdentifier: "showFunny", sender: nil)
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
