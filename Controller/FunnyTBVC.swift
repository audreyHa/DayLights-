//
//  FunnyTBVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/28/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class FunnyTBVC: UITableViewController {

    var daylights=[Daylight](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daylights=CoreDataHelper.retrieveDaylight()
        //        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        daylights = daylights.sorted(by: { $0.dateCreated!.compare($1.dateCreated!) == .orderedDescending })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daylights.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FunnyTableViewCell", for: indexPath) as! FunnyTableViewCell
        
        let daylight=daylights[indexPath.row]
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let now = dateformatter.string(from: daylight.dateCreated!)
        cell.funnyDate.text=now
        cell.funnyData.text=daylight.funny
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            let daylightToDelete=daylights[indexPath.row]
            CoreDataHelper.delete(daylight: daylightToDelete)
            daylights=CoreDataHelper.retrieveDaylight()
            daylights = daylights.sorted(by: { $0.dateCreated!.compare($1.dateCreated!) == .orderedDescending })
        }
    }
}
