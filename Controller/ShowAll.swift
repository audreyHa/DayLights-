//
//  ShowAll.swift
//  DayLights
//
//  Created by Audrey Ha on 4/13/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Crashlytics

class ShowAll: UITableViewController {

    var daylights=[Daylight](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEvent(withName: "Opened Show All DayLights", customAttributes: nil)
        daylights=CoreDataHelper.retrieveDaylight()
        tableView.rowHeight = UITableView.automaticDimension
        daylights = daylights.sorted(by: { $0.dateCreated!.compare($1.dateCreated!) == .orderedDescending })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daylights.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowAllCell", for: indexPath) as! ShowAllCell
        
        let daylight=daylights[indexPath.row]
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let now = dateformatter.string(from: daylight.dateCreated!)
        cell.dateLabel.text=now
        cell.gratefulText.text=daylight.funny
        cell.didWellText.text=daylight.didWell
        
        if daylight.mood==1{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale1")
        }else if daylight.mood==2{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale2")
        }else if daylight.mood==3{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale3")
        }else if daylight.mood==4{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale4")
        }else if daylight.mood==5{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale5")
        }else{
            cell.moodLabel.text="No Mood Entered!"
        }
        return cell
    }
    

   
}
