//
//  ViewController.swift
//  DayLights
//
//  Created by Audrey Ha on 3/25/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class ViewController: UIViewController, UITabBarControllerDelegate {
    var daylight: Daylight?
    
    var red = UIColor(red: 41.0/255.0, green: 220.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    var count=0
    var currentMood=0
    var daylightsArray=[Daylight]()
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var didWellText: UITextView!
    @IBOutlet weak var gratefulMomentText: UITextView!
    
    @IBOutlet weak var mood1: UIButton!
    @IBOutlet weak var mood2: UIButton!
    @IBOutlet weak var mood3: UIButton!
    @IBOutlet weak var mood4: UIButton!
    @IBOutlet weak var mood5: UIButton!
    
    @IBOutlet weak var gratefulLabel: UILabel!
    @IBOutlet weak var didWellLabel: UILabel!
    
    @IBOutlet weak var topPurple: UIImageView!
    @IBOutlet weak var midPurple: UIImageView!
    @IBOutlet weak var bottomPurple: UIImageView!
    
    var moodButtons=[UIButton]()

    @IBAction func mood1(_ sender: UIButton) {
        setMoodButton(currentButton: mood1, value: 1)
    }
    
    @IBAction func mood2(_ sender: UIButton) {
        setMoodButton(currentButton: mood2, value: 2)
    }
    
    @IBAction func mood3(_ sender: UIButton) {
        setMoodButton(currentButton: mood3, value: 3)
    }
    
    @IBAction func mood4(_ sender: UIButton) {
        setMoodButton(currentButton: mood4, value: 4)
    }
    
    @IBAction func mood5(_ sender: UIButton) {
        setMoodButton(currentButton: mood5, value: 5)
    }
    
    func setMoodButton(currentButton: UIButton, value: Int){
        currentButton.layer.borderWidth=3
        currentButton.layer.borderColor = red.cgColor
        currentMood=value
        
        for button in moodButtons{
            if button != currentButton{
                button.layer.borderWidth=0
            }
        }
    }
    
    
    @IBAction func onMoreTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("OpenSideMenu"), object: nil)
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        var datePicker = UIDatePicker()

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore{
            print("Not first launch.")
        }else{
            makePrivacyAlert()
            print("First time opening app")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
           
        }
    }

    func setNotificationTime(){
        let content=UNMutableNotificationContent()
        content.title="DayHighlights Alert!"
        content.body="Make sure to fill out your DayHighlights for today!"
        content.sound=UNNotificationSound.default
        
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        
        // Change the time to 7:00:00 in your locale
        components.hour = 12
        components.minute = 0
        components.second = 0
        
        let date = gregorian.date(from: components)!
        
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let request=UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func saveWhatYouHave(){
            if (didWellText.text==""){
                daylight!.didWell="None entered"
            }else{
                daylight!.didWell=didWellText.text!
            }
        
            //COMMENT! You would save grateful things and joyful moments instead here
            if (gratefulMomentText.text==""){
                daylight!.gratefulThing="None entered"
            }else{
                daylight!.gratefulThing=gratefulMomentText.text!
            }
            
            //COMMENT change this to saving dummy data for stressful moment for V2
            daylight!.stressfulMoment="No Stressful Moment entered"
//            daylight!.gratefulThing="No Grateful Thing Entered."
            daylight!.funny="No Joyful Moment Entered"
            
            if currentMood != 0{
                daylight!.mood=Int32(currentMood) ?? 3
            }
            
            currentMood=0
        
            if (daylight!.dateCreated == nil){
                daylight!.dateCreated=Date()
            }
            
            currentMood=0
            CoreDataHelper.saveDaylight()
        
    }
    
    func resetEverything(){
        count=0
        currentMood=0
        didWellText.text = ""
        gratefulMomentText.text = ""
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let now = dateformatter.string(from: Date())
        dateLabel.text=now
        dayLightsTitleLabel.text="DayHighlights"
        mood1.layer.borderWidth=0
        mood2.layer.borderWidth=0
        mood3.layer.borderWidth=0
        mood4.layer.borderWidth=0
        mood5.layer.borderWidth=0
        daylight=nil
    }
    
    @IBAction func saveDayLights(_ sender: UIButton) {
        var array=CoreDataHelper.retrieveDaylight()
        
            if daylight != nil{ //saving old
                if (didWellText.text != "")&&(gratefulMomentText.text != "")&&(currentMood != 0){
                    Analytics.logEvent("resaveOld", parameters: nil)
                    
                    saveWhatYouHave()
                    resetEverything()
                    moodIsNotGreat()
                }else if (currentMood != 0){ //text fields are incomplete
                    print("not going to save because no text entered")
                    
                    UserDefaults.standard.set("enterDHText",forKey: "typeOKAlert")
                    makeOKAlert()
                }else{ //mood is also incomplete
                    UserDefaults.standard.set("enterAllDH",forKey: "typeOKAlert")
                    makeOKAlert()
                }
            }else{ //saving new
                if (didWellText.text != "")&&(gratefulMomentText.text != "")&&(currentMood != 0){
                    Analytics.logEvent("saveNew", parameters: nil)
                    
                    var tempCurrentMood=currentMood
                    
                    daylight=CoreDataHelper.newDaylight()
                    saveWhatYouHave()
                    resetEverything()
                    moodIsNotGreat()
                    
                    if tempCurrentMood < 3{
                        UserDefaults.standard.set("todayStressGames",forKey: "typeOKAlert")
                        makeOKAlert()
                    }else{ //mood is fine
                        let vc = storyboard!.instantiateViewController(withIdentifier: "ControlPanelVC") as! ControlPanelVC
                        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
                        vc.view.backgroundColor = transparentGrey
                        vc.modalPresentationStyle = .overCurrentContext
                        present(vc, animated: true, completion: nil)
                    }
                    
                }else if (currentMood != 0){ //text fields are incomplete
                    print("not going to save because no text entered")
                    
                    UserDefaults.standard.set("enterDHText",forKey: "typeOKAlert")
                    makeOKAlert()

                }else{ //mood is also incomplete
                    UserDefaults.standard.set("enterAllDH",forKey: "typeOKAlert")
                    makeOKAlert()
                }
            }
    }

    @IBAction func cancelButton(_ sender: UIButton) {
        resetEverything()
        currentMood=0
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
            UserDefaults.standard.set("weeksTalkToFriend",forKey: "typeOKAlert")
            makeOKAlert()

        }else if((weekDatesToCheck.count==weekCheck)||(weekDatesToCheck.count-1 == weekCheck))&&(weekCheckEachDateCount>=5){
            UserDefaults.standard.set("weekTalkToFriend",forKey: "typeOKAlert")
            makeOKAlert()

        }else if(checkingCount==datesToCheck.count)&&(threeDayCount==3){
            UserDefaults.standard.set("stressGames",forKey: "typeOKAlert")
            makeOKAlert()
        }
        
        print("Double week each count \(doubleWeekEachDateCount)")
        print("week each count \(weekCheckEachDateCount)")
        print("3 day count \(threeDayCount)")
    }
    
    func makeOKAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "OKAlert") as! OKAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func makePrivacyAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "PrivacyPolicyAlert") as! PrivacyPolicyAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func makeEnterNotiAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "EnterNotiAlert") as! EnterNotiAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLightsTitleLabel: UILabel!
    
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.adjustsFontSizeToFitWidth=true
        daylightsArray=CoreDataHelper.retrieveDaylight()
        
        gratefulLabel.adjustsFontSizeToFitWidth=true
        didWellLabel.adjustsFontSizeToFitWidth=true
        let clearedStressful = UserDefaults.standard.bool(forKey: "clearedStressful")
        if clearedStressful{
            print("DON'T need to add stressful moment.")
        }else{
            print("NEED to add stressful moment.")
            daylightsArray=CoreDataHelper.retrieveDaylight()
            for item in daylightsArray{
                if item.stressfulMoment == nil{
                    item.stressfulMoment="Need To Enter Stressful Moment"
                }
                
                CoreDataHelper.saveDaylight()
            }

            UserDefaults.standard.set(true, forKey: "clearedStressful")
            daylightsArray=CoreDataHelper.retrieveDaylight()
        }
        
        moodButtons=[mood1, mood2, mood3, mood4, mood5]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        saveButton.layer.cornerRadius = 25
        saveButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 25
        cancelButton.layer.masksToBounds = true
        
        topPurple.layer.cornerRadius=10
        midPurple.layer.cornerRadius=10
        bottomPurple.layer.cornerRadius=10
        
        self.topPurple.layer.masksToBounds = true
        self.midPurple.layer.masksToBounds = true
        self.bottomPurple.layer.masksToBounds = true

        didWellText.layer.cornerRadius=10
        gratefulMomentText.layer.cornerRadius=10
        
        var red = UIColor(red: 41.0/255.0, green: 220.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDidWell), name: NSNotification.Name("showDidWell"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(searchDayLights), name: NSNotification.Name("searchDayLights"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showMood), name: NSNotification.Name("ShowMood"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stressCrisis), name: NSNotification.Name("stressCrisis"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stressGames), name: NSNotification.Name("stressGames"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notiTime), name: NSNotification.Name("notiTime"), object: nil)
        
        self.hideSide()
        self.hideKeyboardWhenTappedAround() 
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let newnow = dateformatter.string(from: Date())
        
        dateLabel.text=newnow
        dayLightsTitleLabel.text="DayHighlights"
        dateLabel.adjustsFontSizeToFitWidth=true

    }
    //END of view did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
        if let daylight = daylight{
            // 2
            didWellText.text = daylight.didWell
            gratefulMomentText.text = daylight.gratefulThing
            
            if (daylight.mood==1){
                mood1.layer.borderWidth = 3
                mood1.layer.borderColor = red.cgColor
                currentMood=1
            }else if(daylight.mood==2){
                mood2.layer.borderWidth = 3
                mood2.layer.borderColor = red.cgColor
                currentMood=2
            }else if(daylight.mood==3){
                mood3.layer.borderWidth = 3
                mood3.layer.borderColor = red.cgColor
                currentMood=3
            }else if(daylight.mood==4){
                mood4.layer.borderWidth = 3
                mood4.layer.borderColor = red.cgColor
                currentMood=4
            }else if(daylight.mood==5){
                mood5.layer.borderWidth = 3
                mood5.layer.borderColor = red.cgColor
                currentMood=5
            }
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yy"
            
            dateLabel.text="Created on \(dateformatter.string(from: daylight.dateCreated!))"
            dayLightsTitleLabel.text="Editing"
            
        } else {
            // 3
            didWellText.text = ""
            gratefulMomentText.text = ""
        }
    }

    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        
    }
    
    @objc func notiTime(notification: NSNotification) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
       makeEnterNotiAlert()
    }
    
    //START keyboard modifying functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height/3)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @objc func keyboardWillChange(notification: Notification){
        
    }
    
    @objc func searchDayLights(){
        performSegue(withIdentifier: "search", sender: nil)
    }
    
    @objc func showDidWell(){
        self.tabBarController?.selectedIndex = 1
        
    }
    
    @objc func stressCrisis(){
        performSegue(withIdentifier: "stressCrisis", sender: nil)
    }
    
    @objc func stressGames(){
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func showMood(){
        self.tabBarController?.selectedIndex = 4
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
