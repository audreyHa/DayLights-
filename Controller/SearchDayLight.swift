//
//  SearchDayLight.swift
//  DayLights
//
//  Created by Audrey Ha on 4/13/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class SearchDayLight: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var selectedDate=[Daylight]()
    @IBAction func searchPressed(_ sender: UIButton) {
        selectedDate=[]
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        var strDate = dateformatter.string(from: datePicker.date)
        
        var daylightsArray=CoreDataHelper.retrieveDaylight()
        for daylight in daylightsArray{
            var daylightDate=dateformatter.string(from: daylight.dateCreated!)
            if daylightDate == strDate{
                selectedDate=[]
                selectedDate.append(daylight)
            }
        }
        
        if selectedDate.count==0{
            UserDefaults.standard.set("noDaylightToday",forKey: "typeOKAlert")
            makeOKAlert()
        }
        tableView.reloadData()
        
    }
    
    func makeOKAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "OKAlert") as! OKAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDate.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDayLightCell", for: indexPath) as! SearchDayLightCell
        cell.didWellText.text=""
        cell.stressfulMoment.text=""
        cell.moodImage.image=nil
        cell.moodText.text="Mood:"
        
        cell.didWellText.text=selectedDate[0].didWell
        cell.stressfulMoment.text=selectedDate[0].stressfulMoment
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        cell.dateText.text=dateformatter.string(from: selectedDate[0].dateCreated!)
        if selectedDate[0].mood==1{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale1")
        }else if selectedDate[0].mood==2{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale2")
        }else if selectedDate[0].mood==3{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale3")
        }else if selectedDate[0].mood==4{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale4")
        }else if selectedDate[0].mood==5{
            cell.moodImage.image=#imageLiteral(resourceName: "emojiScale5")
        }else{
            cell.moodText.text="No Mood Entered!"
        }
        
        return cell
    }
}
