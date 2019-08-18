//
//  GraphTableViewCell.swift
//  DayLights
//
//  Created by Audrey Ha on 8/9/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Charts

class GraphTableViewCell: UITableViewCell {

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var monthLabel: UILabel!
    var monthData=[Daylight]()
    var entryNumber=0
    var monthInList=0
    var labels=[String]()
    
    func setChartValues(){
        var values=[ChartDataEntry]()
        var colorTemplates=[ChartColorTemplates.colorful(), ChartColorTemplates.material(), ChartColorTemplates.joyful(), ChartColorTemplates.pastel()]
        for i in 0...entryNumber-1 {
            var val=monthData[i].mood
            values.append(ChartDataEntry(x: Double(i+1), y: Double(val)))
        }
        
        let set1=LineChartDataSet(values: values, label: "\(monthLabel.text!)")
        set1.mode = .cubicBezier
        set1.drawValuesEnabled = false
        set1.drawCirclesEnabled=false
        set1.lineWidth=3
        set1.colors=colorTemplates[monthInList]

        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
        lineChartView.xAxis.granularity = 1
        
        let data=LineChartData(dataSet: set1)
        lineChartView.data=data
        lineChartView.reloadInputViews()
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.axisMaximum=6
        lineChartView.rightAxis.axisMinimum = 0
        lineChartView.rightAxis.axisMaximum = 6
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
