//
//  Chart.swift
//  DayLights
//
//  Created by Audrey Ha on 8/9/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Charts

class Chart: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var daylightsArray=CoreDataHelper.retrieveDaylight()
    var monthYear=[String]()
    var individualMonths=[String]()
    var daylightsPerMonth=[[Daylight]]()
    
    var formalMonthYear=[String]()
    var formalIndividualMonths=[String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getMonths()
        
        self.tableView.allowsSelection = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return individualMonths.count+1
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: GraphTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GraphTableViewCell", for: indexPath) as! GraphTableViewCell
        
        if indexPath.row==0{
            cell.monthData=daylightsArray
            cell.entryNumber=daylightsArray.count
            cell.monthLabel.text="All Month Data"
            
            cell.labels=formalMonthYear
        }else{
            var monthData=daylightsPerMonth[indexPath.row-1]
            var monthName=formalIndividualMonths[indexPath.row-1]
            var tempLabelsArray=[String]()
            
            for day in monthData{
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MM/dd"
                let dateCreated=dateformatter.string(from: day.dateCreated!)
                tempLabelsArray.append(dateCreated)
            }
            cell.monthLabel.text=monthName
            cell.monthData=monthData
            cell.entryNumber=monthData.count
            cell.labels=tempLabelsArray
        }
        
        cell.monthInList=indexPath.row%4
        
        cell.setChartValues()
        cell.setNeedsDisplay()
        return cell
    }
    
    func getMonths(){
        //get array of each daylight's month year
        for daylight in daylightsArray{
            var monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MM"
            var month = monthFormatter.string(from: daylight.dateCreated!)
            
            var yearFormatter=DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            var year = yearFormatter.string(from: daylight.dateCreated!)
            
            monthYear.append("\(month) \(year)")
            
            switch(month){
            case "01":
                formalMonthYear.append("January \(year)")
            case "02":
                formalMonthYear.append("February \(year)")
            case "03":
                formalMonthYear.append("March \(year)")
            case "04":
                formalMonthYear.append("April \(year)")
            case "05":
                formalMonthYear.append("May \(year)")
            case "06":
                formalMonthYear.append("June \(year)")
            case "07":
                formalMonthYear.append("July \(year)")
            case "08":
                formalMonthYear.append("August \(year)")
            case "09":
                formalMonthYear.append("September \(year)")
            case "10":
                formalMonthYear.append("October \(year)")
            case "11":
                formalMonthYear.append("November \(year)")
            case "12":
                formalMonthYear.append("December \(year)")
            default:
                break
            }
        }
        
        //get all the individual month years into an array
        for i in 0...monthYear.count-1{
            if individualMonths.contains(monthYear[i]){
                continue
            }else{
                individualMonths.append(monthYear[i])
            }
        }
        
        for i in 0...formalMonthYear.count-1{
            if formalIndividualMonths.contains(formalMonthYear[i]){
                continue
            }else{
                formalIndividualMonths.append(formalMonthYear[i])
            }
        }
        
        for month in individualMonths{
            daylightsPerMonth.append([])
        }
        
        //sort the daylights into arrays by their month year
        for i in 0...monthYear.count-1{
            for j in 0...individualMonths.count-1{
                if individualMonths[j]==monthYear[i]{
                    daylightsPerMonth[j].append(daylightsArray[i])
                }
            }
        }
        
        formalIndividualMonths.reverse()
        individualMonths.reverse()
        daylightsPerMonth.reverse()
    }
    
}
