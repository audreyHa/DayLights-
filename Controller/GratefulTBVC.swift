//
//  GratefulTBVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/27/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class GratefulTBVC: UITableViewController {

    var daylights=[Daylight](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daylights=CoreDataHelper.retrieveDaylight()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daylights.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GratefulTableViewCell", for: indexPath) as! GratefulTableViewCell
        
        let daylight=daylights[indexPath.row]
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let now = dateformatter.string(from: daylight.dateCreated!)
        cell.gratefulDate.text=now
        cell.gratefulText.text=daylight.gratefulThing
        
        return cell
    }

}
