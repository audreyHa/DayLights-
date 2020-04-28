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
    @IBOutlet weak var statsButton: UIButton!
    
    var daylightsArray=CoreDataHelper.retrieveDaylight()
    var monthYear=[String]()
    var individualMonths=[String]()
    var daylightsPerMonth=[[Daylight]]()
    
    var formalMonthYear=[String]()
    var formalIndividualMonths=[String]()

    var purpleColors=[UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.allowsSelection = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        statsButton.layer.cornerRadius=20
        
        purpleColors=[UIColor(rgb: 0xDBF3FC),UIColor(rgb: 0xCDD9F1),UIColor(rgb: 0xb0b6ff),UIColor(rgb: 0xa495e8),UIColor(rgb: 0xcda3ff)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        daylightsArray=CoreDataHelper.retrieveDaylight()
        getMonths()
        tableView.reloadData()
    }
    
    @IBAction func xPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return individualMonths.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: GraphTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GraphTableViewCell", for: indexPath) as! GraphTableViewCell
        
        cell.purpleView.layer.cornerRadius=15
        cell.lineChartView.backgroundColor=UIColor.white
        cell.purpleView.backgroundColor=purpleColors[indexPath.row%6]
        
        
        cell.whiteGraphSurroundView.layer.cornerRadius=15
        cell.lineChartView.rightAxis.drawLabelsEnabled=false
           
            var monthData=daylightsPerMonth[indexPath.row]
            var monthDoubles=[Double]()
            for daylight in daylightsPerMonth[indexPath.row]{
                var val=0.0
                switch(daylight.mood){
                case 1:
                    val=5.0
                case 2:
                    val=4.0
                case 3:
                    val=3.0
                case 4:
                    val=2.0
                case 5:
                    val=1.0
                default:
                    val=3.0
                }
                monthDoubles.append(val)
            }

            
            var monthName=formalIndividualMonths[indexPath.row]
            var tempLabelsArray=[String]()
            
            for day in monthData{
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MM/dd"
                let dateCreated=dateformatter.string(from: day.dateCreated!)
                tempLabelsArray.append(dateCreated)
            }
            cell.monthLabel.text=monthName
            cell.monthData=monthData
            cell.monthDoubles=monthDoubles
            cell.entryNumber=monthData.count
            cell.labels=tempLabelsArray
        
        
        cell.monthInList=indexPath.row%4
        
        cell.setChartValues()
        cell.setNeedsDisplay()
        return cell
    }
    
    func getMonths(){
        //get array of each daylight's month year
        
        monthYear=[]
        individualMonths=[]
        daylightsPerMonth=[]
        formalMonthYear=[]
        formalIndividualMonths=[]
        
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
                formalMonthYear.append("Jan \(year)")
            case "02":
                formalMonthYear.append("Feb \(year)")
            case "03":
                formalMonthYear.append("Mar \(year)")
            case "04":
                formalMonthYear.append("Apr \(year)")
            case "05":
                formalMonthYear.append("May \(year)")
            case "06":
                formalMonthYear.append("Jun \(year)")
            case "07":
                formalMonthYear.append("Jul \(year)")
            case "08":
                formalMonthYear.append("Aug \(year)")
            case "09":
                formalMonthYear.append("Sep \(year)")
            case "10":
                formalMonthYear.append("Oct \(year)")
            case "11":
                formalMonthYear.append("Nov \(year)")
            case "12":
                formalMonthYear.append("Dec \(year)")
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
        
        print(monthYear)
        //sort the daylights into arrays by their month year
        for i in 0...monthYear.count-1{
            for j in 0...individualMonths.count-1{
                if individualMonths[j]==monthYear[i]{
                    print(i)
                    daylightsPerMonth[j].append(daylightsArray[i])
                }
            }
        }
        
        //remove any arrays from daylightsPerMonth if count is <2. Then remove same value from formalIndividualMonths and individualMonths
        var i=0
        for array in daylightsPerMonth{
            if array.count<2{
                daylightsPerMonth=daylightsPerMonth.filter {$0 != array}
                print("Array \(array)")
                print("Formal individual months \(formalIndividualMonths)")
                formalIndividualMonths.remove(at: i)
                individualMonths.remove(at: i)
            }
            
            i += 1
        }
        
        formalIndividualMonths.reverse()
        individualMonths.reverse()
        daylightsPerMonth.reverse()
    }
    
}
