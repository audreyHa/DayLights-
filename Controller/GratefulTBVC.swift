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
        tableView.rowHeight = UITableView.automaticDimension
        daylights = daylights.sorted(by: { $0.dateCreated!.compare($1.dateCreated!) == .orderedDescending })
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            let daylightToDelete=daylights[indexPath.row]
            CoreDataHelper.delete(daylight: daylightToDelete)
            CoreDataHelper.saveDaylight()
            daylights=CoreDataHelper.retrieveDaylight()
            daylights = daylights.sorted(by: { $0.dateCreated!.compare($1.dateCreated!) == .orderedDescending })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        guard let identifier = segue.identifier,
            let destination = segue.destination as? ViewController
            else { return }
        
        switch identifier {
            // 2
            
        case "edit":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // 2
            let daylight = daylights[indexPath.row]
            // 3
            let destination = segue.destination as! ViewController
            // 4
            destination.daylight = daylight
            
        default:
            print("unexpected segue identifier")
        }
    }
}
