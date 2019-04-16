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
    var cellRow=0
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        daylights=CoreDataHelper.retrieveDaylight()
        daylights = daylights.sorted(by: { $0.dateCreated!.compare($1.dateCreated!) == .orderedDescending })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return daylights.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DidWellTableViewCell", for: indexPath) as! DidWellTableViewCell
        
        let daylight=daylights[indexPath.row]

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let now = dateformatter.string(from: daylight.dateCreated!)
        cell.didWellDate.text=now
        cell.didWellText.text=daylight.didWell

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellRow=indexPath.row
        createAlert(title: "ALERT!", message: "Do you want to edit this DayLight?")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        guard let identifier = segue.identifier,
            let destination = segue.destination as? ViewController
            else { return }
        
        switch identifier {
        // 2
        
        case "edit":
            let daylight = daylights[cellRow]
            // 3
            let destination = segue.destination as! ViewController
            // 4
            destination.daylight = daylight
            
        default:
            print("unexpected segue identifier")
        }
    }

    func createAlert(title: String, message: String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"Yes", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "edit", sender: nil)
        }))
        alert.addAction(UIAlertAction(title:"No", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
