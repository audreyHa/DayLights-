//
//  MoodVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/29/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class MoodVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var todayImage: UIImageView!
    @IBOutlet weak var weekImage: UIImageView!
    @IBOutlet weak var monthImage: UIImageView!
    @IBOutlet weak var yearImage: UIImageView!
    
    @IBOutlet weak var topPurple: UIImageView!
    @IBOutlet weak var purple1: UIImageView!
    @IBOutlet weak var purple2: UIImageView!
    @IBOutlet weak var purple3: UIImageView!
    @IBOutlet weak var purple4: UIImageView!
    
    
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var orangeLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    
    func updateMoodCounts(){
        var daylightsArray=CoreDataHelper.retrieveDaylight()
        var redCount=0
        var orangeCount=0
        var yellowCount=0
        var greenCount=0
        var blueCount=0
        
        for daylight in daylightsArray{
            switch(daylight.mood){
            case 1:
                redCount+=1
            case 2:
                orangeCount+=1
            case 3:
                yellowCount+=1
            case 4:
                greenCount+=1
            case 5:
                blueCount+=1
            default:
                print("Don't do anything")
            }
        }
        
        blueLabel.text="\(blueCount)"
        greenLabel.text="\(greenCount)"
        yellowLabel.text="\(yellowCount)"
        orangeLabel.text="\(orangeCount)"
        redLabel.text="\(redCount)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var labels=[moodLabel, weekLabel, monthLabel, yearLabel]
        
        for label in labels{
            label!.layer.masksToBounds=true
            label!.layer.cornerRadius=5
            label?.adjustsFontSizeToFitWidth=true
        }

        topPurple.layer.cornerRadius=20
        purple1.layer.cornerRadius=20
        purple2.layer.cornerRadius=20
        purple3.layer.cornerRadius=20
        purple4.layer.cornerRadius=20
        
        self.topPurple.layer.masksToBounds = true
        self.purple1.layer.masksToBounds = true
        self.purple2.layer.masksToBounds = true
        self.purple3.layer.masksToBounds = true
        self.purple4.layer.masksToBounds = true
        
        headerLabel.adjustsFontSizeToFitWidth=true

    }//end of view did load
    
    override func viewDidAppear(_ animated: Bool) {
        updateMoodCounts()
            
        var daylightsArray=[Daylight]()
        daylightsArray=CoreDataHelper.retrieveDaylight()
        daylightsArray = daylightsArray.sorted(by: { $0.dateCreated!.compare($1.dateCreated!) == .orderedDescending })
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        
        let todaysDate = dateformatter.string(from: Date())
        
        var todayMood=0
        var weekMood=0
        var monthMood=0
        var yearMood=0

        //today's mood
        var todayMoodSum=0
        var todayCount=0
        for daylight in daylightsArray{
            if daylight.mood != 0{
                let theDate=daylight.dateCreated
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MM/dd/yy"
                let daylightDate = dateformatter.string(from: theDate!)
                if (todaysDate==daylightDate){
                    todayMoodSum += Int(daylight.mood)
                    todayCount += 1
                }
            }
            
        }
        
        if (todayCount != 0){
            var averageToday: Double
            var newtodayMoodSum=Double(todayMoodSum)
            var newtodayCount=Double(todayCount)
            averageToday=Double(newtodayMoodSum/newtodayCount)
            averageToday.round()
            todayMood=Int(averageToday)
        }else{
            moodLabel.text="No Data Entered Today!"
        }
        
        //week mood
        var weekMoodSum=0
        var weekCount=0
        
        let calendar = Calendar.current
        let weekDateformatter = DateFormatter()
        weekDateformatter.dateFormat = "MM/dd/yy"
        let todayStringDate = weekDateformatter.string(from: Date())
        let today = calendar.startOfDay(for: Date())
        let yesterday=weekDateformatter.string(from: today.addingTimeInterval(TimeInterval(-86400)))
        let yesterday2=weekDateformatter.string(from: today.addingTimeInterval(TimeInterval(-172800)))
        let yesterday3=weekDateformatter.string(from: today.addingTimeInterval(TimeInterval(-259200)))
        let yesterday4=weekDateformatter.string(from: today.addingTimeInterval(TimeInterval(-345600)))
        let yesterday5=weekDateformatter.string(from: today.addingTimeInterval(TimeInterval(-432000)))
        let yesterday6=weekDateformatter.string(from: today.addingTimeInterval(TimeInterval(-518400)))
        
        for daylight in daylightsArray{
            if daylight.mood != 0{
                let theDate=daylight.dateCreated
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MM/dd/yy"
                let daylightDate = dateformatter.string(from: theDate!)
                if (todayStringDate==daylightDate)||(yesterday==daylightDate)||(yesterday2==daylightDate)||(yesterday3==daylightDate)||(yesterday4==daylightDate)||(yesterday5==daylightDate)||(yesterday6==daylightDate){
                    weekMoodSum += Int(daylight.mood)
                    weekCount+=1
                }
            }
            
        }
        
        print("week mood sum \(weekMoodSum) week count \(weekCount)")
        if (weekCount != 0){
            var averageWeek: Double
            var newweekMoodSum=Double(weekMoodSum)
            var newweekCount=Double(weekCount)
            averageWeek=Double(newweekMoodSum/newweekCount)
            print(averageWeek)
            averageWeek.round()
            print("average Week ROUNDED \(averageWeek)")
            weekMood=Int(averageWeek)
        }else{
            weekLabel.text="No Data Entered This Week!"
        }
        
        
        
        print("weekdays \(yesterday) \(yesterday2) \(yesterday3) \(yesterday4) \(yesterday5) \(yesterday6)")
    
        //month mood
        var monthMoodSum=0
        var count=0
        let newDateformatter = DateFormatter()
        newDateformatter.dateFormat = "MM"
        let currentMonth = newDateformatter.string(from: Date())
        
        for daylight in daylightsArray{
            if daylight.mood != 0{
                let theDate=daylight.dateCreated
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MM"
                let daylightDate = dateformatter.string(from: theDate!)
                if (currentMonth==daylightDate){
                    monthMoodSum += Int(daylight.mood)
                    count+=1
                }
            }
            
        }
        
        if (count != 0){
            var averageMonth: Double
            var newmonthMoodSum=Double(monthMoodSum)
            var newcount=Double(count)
            averageMonth=Double(newmonthMoodSum/newcount)
            averageMonth.round()
            monthMood=Int(averageMonth)
        }else{
            moodLabel.text="No Data Entered This Month!"
        }
        
        
        //year mood
        var yearMoodSum=0
        var yearCount=0
        let yearDateformatter = DateFormatter()
        yearDateformatter.dateFormat = "MM/dd/yy"
        let currentYear=yearDateformatter.string(from: Date())
        
        
        for daylight in daylightsArray{
            if daylight.mood != 0{
                let theDate=daylight.dateCreated
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MM/dd/yy"
                let daylightDate = dateformatter.string(from: theDate!)
                if (String(currentYear.suffix(2)) == String(daylightDate.suffix(2))){
                    yearMoodSum += Int(daylight.mood)
                    yearCount+=1
                    
                }
            }
            
        }
        
        if (yearCount != 0){
            var averageYear: Double
            var newyearMoodSum=Double(yearMoodSum)
            var newyearCount=Double(yearCount)
            averageYear=Double(newyearMoodSum/newyearCount)
            averageYear.round()
            yearMood=Int(averageYear)
        }else{
            moodLabel.text="No Data Entered This Year!"
        }
        
        print("today \(todayMood)")
        print("week \(weekMood)")
        print("month \(monthMood)")
        print("year \(yearMood)")
        
        //setting the images
        var array=[todayImage, weekImage, monthImage, yearImage]
        var valuesArray=[todayMood, weekMood, monthMood, yearMood]
        var inArray=array.count-1
        
        for number in 0...inArray{
            if (valuesArray[number]==1){
                array[number]!.image = #imageLiteral(resourceName: "emojiScale1")
            }else if(valuesArray[number]==2){
                array[number]!.image = #imageLiteral(resourceName: "emojiScale2")
            }else if(valuesArray[number]==3){
                array[number]!.image = #imageLiteral(resourceName: "emojiScale3")
            }else if(valuesArray[number]==4){
                array[number]!.image = #imageLiteral(resourceName: "emojiScale4")
            }else if(valuesArray[number]==5){
                array[number]!.image = #imageLiteral(resourceName: "emojiScale5")
            }
        }
    }
    @IBAction func xPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}



