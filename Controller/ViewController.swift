//
//  ViewController.swift
//  DayLights
//
//  Created by Audrey Ha on 3/25/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var red = UIColor(red: 155.0/255.0, green: 219.0/255.0, blue: 174.0/255.0, alpha: 1.0)
    var count=0
    var currentMood=0
    var daylightsArray=[Daylight]()
    @IBOutlet weak var didWellText: UITextView!
    @IBOutlet weak var gratefulText: UITextView!
    @IBOutlet weak var funnyText: UITextView!
    
    @IBOutlet weak var mood1: UIButton!
    @IBOutlet weak var mood2: UIButton!
    @IBOutlet weak var mood3: UIButton!
    @IBOutlet weak var mood4: UIButton!
    @IBOutlet weak var mood5: UIButton!
    @IBAction func mood1(_ sender: UIButton) {
        mood1.layer.borderWidth = 3
        mood1.layer.borderColor = red.cgColor
        currentMood=1
        mood2.layer.borderWidth=0
        mood3.layer.borderWidth=0
        mood4.layer.borderWidth=0
        mood5.layer.borderWidth=0
        
    }
    
    @IBAction func mood2(_ sender: UIButton) {
        mood2.layer.borderWidth = 3
        mood2.layer.borderColor = red.cgColor
        currentMood=2
        mood1.layer.borderWidth=0
        mood3.layer.borderWidth=0
        mood4.layer.borderWidth=0
        mood5.layer.borderWidth=0
    }
    
    @IBAction func mood3(_ sender: UIButton) {
        mood3.layer.borderWidth = 3
        mood3.layer.borderColor = red.cgColor
        currentMood=3
        mood2.layer.borderWidth=0
        mood1.layer.borderWidth=0
        mood4.layer.borderWidth=0
        mood5.layer.borderWidth=0
    }
    
    @IBAction func mood4(_ sender: UIButton) {
        mood4.layer.borderWidth = 3
        mood4.layer.borderColor = red.cgColor
        currentMood=4
        mood2.layer.borderWidth=0
        mood3.layer.borderWidth=0
        mood1.layer.borderWidth=0
        mood5.layer.borderWidth=0
    }
    
    @IBAction func mood5(_ sender: UIButton) {
        mood5.layer.borderWidth = 3
        mood5.layer.borderColor = red.cgColor
        currentMood=5
        mood2.layer.borderWidth=0
        mood3.layer.borderWidth=0
        mood4.layer.borderWidth=0
        mood1.layer.borderWidth=0
    }
    
    
    @IBOutlet weak var contentsView: UIView!
    
    @IBAction func onMoreTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("OpenSideMenu"), object: nil)
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveDayLights(_ sender: UIButton) {
        
        daylightsArray=CoreDataHelper.retrieveDaylight()
        
        var count=0;
        for value in daylightsArray{
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
            
            daylight.mood=Int32(currentMood)
            print(currentMood)
            currentMood=0
            daylight.dateCreated=Date()
            CoreDataHelper.saveDaylight()
            didWellText.text = ""
            gratefulText.text = ""
            funnyText.text=""
            mood1.layer.borderWidth=0
            mood2.layer.borderWidth=0
            mood3.layer.borderWidth=0
            mood4.layer.borderWidth=0
            mood5.layer.borderWidth=0
            
            moodIsNotGreat()
        }else{
            let comeLater = UIAlertController(title: "ALERT!", message: "Looks like you've already created 1 DayLights for today. See you tomorrow!", preferredStyle: UIAlertController.Style.alert)
            comeLater.addAction(UIAlertAction(title: "OK!", style: UIAlertAction.Style.default, handler: nil))
            self.present(comeLater, animated: true, completion: nil)
            
            count=0
            self.didWellText.text = ""
            self.gratefulText.text = ""
            self.funnyText.text=""
            self.mood1.layer.borderWidth=0
            self.mood2.layer.borderWidth=0
            self.mood3.layer.borderWidth=0
            self.mood4.layer.borderWidth=0
            self.mood5.layer.borderWidth=0
        }
        
    }

    
    func moodIsNotGreat(){
        let calendar = Calendar.current
        let weekDateformatter = DateFormatter()
        weekDateformatter.dateFormat = "MM/dd/yy"
        
        var threeDayDatesArray=[String]()
        var datesArray=[String]()
        var weekDatesArray=[String]()
        
        let todayStringDate = weekDateformatter.string(from: Date())
        threeDayDatesArray.append(todayStringDate)
        datesArray.append(todayStringDate)
        weekDatesArray.append(todayStringDate)
        
        let today = calendar.startOfDay(for: Date())
        
        for i in 1...2{
            threeDayDatesArray.append(weekDateformatter.string(from: today.addingTimeInterval(TimeInterval(-86400*i))))
        }
        
        for i in 1...6{
            weekDatesArray.append(weekDateformatter.string(from: today.addingTimeInterval(TimeInterval(-86400*i))))
        }
        
        for i in 1...13{
            datesArray.append(weekDateformatter.string(from: today.addingTimeInterval(TimeInterval(-86400*i))))
        }
        
        var datesToCheck=[Daylight]()
        var weekDatesToCheck=[Daylight]()
        var doubleWeekToCheck=[Daylight]()
        var weekCheck=0
        var checkingCount=0
        var doubleCheck=0
        
        self.daylightsArray=CoreDataHelper.retrieveDaylight()
        for daylight in self.daylightsArray{
            if (daylight.mood != 0){
                var daylightDate=weekDateformatter.string(from: daylight.dateCreated!)
                if ((daylightDate==datesArray[0])||(daylightDate==datesArray[1])||(daylightDate==datesArray[2])){
                    datesToCheck.append(daylight)
                    weekDatesToCheck.append(daylight)
                    doubleWeekToCheck.append(daylight)
                }
                if ((daylightDate==datesArray[3])||(daylightDate==datesArray[4])||(daylightDate==datesArray[5])||(daylightDate==datesArray[6])){
                    weekDatesToCheck.append(daylight)
                    doubleWeekToCheck.append(daylight)
                }
                if ((daylightDate==datesArray[7])||(daylightDate==datesArray[8])||(daylightDate==datesArray[9])||(daylightDate==datesArray[10])||(daylightDate==datesArray[11])||(daylightDate==datesArray[12])||(daylightDate==datesArray[13])){
                    doubleWeekToCheck.append(daylight)
                }
            }
        }
        
        for date in datesToCheck{
            if (Int(date.mood)<3)&&(Int(date.mood) != 0){
                checkingCount+=1
            }
        }
        
        for weekDate in weekDatesToCheck{
            if(Int(weekDate.mood)<4)&&(Int(weekDate.mood) != 0){
                weekCheck+=1
            }
        }
        
        for doubleDate in doubleWeekToCheck{
            if(Int(doubleDate.mood)<4)&&(Int(doubleDate.mood) != 0){
                doubleCheck+=1
            }
        }
        
        //checking for the three day mood alert
        var threeDay=[String]()
        var threeDayCount=0
        for date in datesToCheck{
            threeDay.append(weekDateformatter.string(from: date.dateCreated!))
        }
        
        for date in threeDayDatesArray{
            if threeDay.contains(date){
                threeDayCount+=1
            }
        }
        
        //checking for the week mood alert
        var weekCheckEachDate=[String]()
        var weekCheckEachDateCount=0
        for date in weekDatesToCheck{
            weekCheckEachDate.append(weekDateformatter.string(from: date.dateCreated!))
        }
        
        for date in weekDatesArray{
            if weekCheckEachDate.contains(date){
                weekCheckEachDateCount+=1
            }
        }
        
        //checking for the 2 week mood alert
        var doubleWeekEachDate=[String]()
        var doubleWeekEachDateCount=0
        for date in doubleWeekToCheck{
            doubleWeekEachDate.append(weekDateformatter.string(from: date.dateCreated!))
        }
        
        for date in datesArray{
            if doubleWeekEachDate.contains(date){
                doubleWeekEachDateCount+=1
            }
        }
        
        
        if((doubleWeekToCheck.count==doubleCheck)||(doubleWeekToCheck.count-1 == doubleCheck)||(doubleWeekToCheck.count-2 == doubleCheck))&&(doubleWeekEachDateCount>=10){
            
                let alert2 = UIAlertController(title: "ALERT!", message: "Looks like your mood has not been good for the past few weeks... Let's look at some resources!", preferredStyle: UIAlertController.Style.alert)
                alert2.addAction(UIAlertAction(title: "Show some resources!", style: UIAlertAction.Style.default, handler: {
                    (action) in
                    alert2.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "resources", sender: nil)
                }))
                self.present(alert2, animated: true, completion: nil)

        }else if((weekDatesToCheck.count==weekCheck)||(weekDatesToCheck.count-1 == weekCheck))&&(weekCheckEachDateCount>=5){
            
                let alert2 = UIAlertController(title: "ALERT!", message: "Looks like you mood has not been great for the past week... Please make sure to talk to a family member or guardian, trusted adult, teacher, or friend.", preferredStyle: UIAlertController.Style.alert)
                alert2.addAction(UIAlertAction(title: "I WILL Talk to Someone!", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)

        }else if(checkingCount==datesToCheck.count)&&(threeDayCount==3){
            
                let alert2 = UIAlertController(title: "ALERT!", message: "Looks like your mood has not been great for the past few days... Try talking to a family member or guardian, trusted adult, teacher, or friend!", preferredStyle: UIAlertController.Style.alert)
                alert2.addAction(UIAlertAction(title: "I'll Talk to Someone", style: UIAlertAction.Style.default, handler:nil))
                self.present(alert2, animated: true, completion: nil)
        }
        
        print("Double week each count \(doubleWeekEachDateCount)")
        print("week each count \(weekCheckEachDateCount)")
        print("3 day count \(threeDayCount)")
    }
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        contentsView.layer.cornerRadius = 8
        contentsView.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 8
        saveButton.layer.masksToBounds = true
        
        contentsView.layer.borderWidth = 3
        var red = UIColor(red: 155.0/255.0, green: 219.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        contentsView.layer.borderColor = red.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDidWell), name: NSNotification.Name("DidWell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGratefulThings), name: NSNotification.Name("GratefulThings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFunny), name: NSNotification.Name("FunnyThings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showMood), name: NSNotification.Name("ShowMood"), object: nil)
        
        self.hideSide()
        self.hideKeyboardWhenTappedAround() 
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let now = dateformatter.string(from: Date())
        
        dateLabel.text=now

    }
    //END of view did load
    
    
    //START keyboard modifying functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height/2)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    //END keyboard modifying functions
    
    
    @objc func keyboardWillChange(notification: Notification){
        
    }
    
    @objc func showDidWell(){
        performSegue(withIdentifier: "showDidWell", sender: nil)
    }
    
    @objc func showGratefulThings(){
        performSegue(withIdentifier: "showGratefulThings", sender: nil)
    }
    
    @objc func showFunny(){
        performSegue(withIdentifier: "showFunny", sender: nil)
    }
    
    @objc func showMood(){
        var daylights=CoreDataHelper.retrieveDaylight()
        
        var count=0
        for value in daylights{
            if (value.mood != 0){
                count+=1
            }
        }
        
        if (count>0){
            performSegue(withIdentifier: "showMood", sender: nil)
        }else{
            let comeLater = UIAlertController(title: "ALERT!", message: "You do not have enough mood data yet. Check back soon!", preferredStyle: UIAlertController.Style.alert)
            comeLater.addAction(UIAlertAction(title: "OK!", style: UIAlertAction.Style.default, handler: nil))
            self.present(comeLater, animated: true, completion: nil)

        }
        
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
