//
//  MoodVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/29/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class MoodVC: UIViewController {
    
    @IBOutlet weak var averageMoodValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var daylightsArray=[Daylight]()
        daylightsArray=CoreDataHelper.retrieveDaylight()
        var moodValues=[Int32]()
        for value in daylightsArray{
            moodValues.append(value.mood)
        }
        var count=0
        var average=0
        for value in moodValues{
            count+=Int(value)
        }
        if (moodValues.count != 0){
            average=(count/moodValues.count)
            var roundedAverage=round(Double(average))
            averageMoodValue.text=String(roundedAverage)
        }else{
            averageMoodValue.text="Not enough mood data to calculate average"
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
