//
//  DidWellTBVC.swift
//  DayLights
//
//  Created by Audrey Ha on 3/27/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class DidWellTBVC: UITableViewController {
    
    var daylights=[Daylight](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daylights=CoreDataHelper.retrieveDaylight()
        print(daylights)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return daylights.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DidWellTableViewCell", for: indexPath) as! DidWellTableViewCell
        
        let daylight=daylights[indexPath.row]
        print("this is the daylight did well \(daylight.didWell)")
        print("this is the daylight did well DATE \(daylight.dateCreated)")
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let now = dateformatter.string(from: daylight.dateCreated!)
        cell.didWellDate.text=now
        cell.didWellText.text=daylight.didWell

        return cell
    }

}
