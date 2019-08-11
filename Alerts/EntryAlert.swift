//
//  EntryAlert.swift
//  DayLights
//
//  Created by Audrey Ha on 8/10/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class EntryAlert: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    var categoryTitles=[String]()
    var categoryContent=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.rowHeight=UITableView.automaticDimension
        self.tableView.estimatedRowHeight=100
        
        okButton.titleLabel!.adjustsFontSizeToFitWidth = true

        var dateToInclude=UserDefaults.standard.string(forKey: "dateToInclude")
        var didWellText=UserDefaults.standard.string(forKey: "didWellText")
        var gratefulText=UserDefaults.standard.string(forKey: "gratefulText")
        var joyfulText=UserDefaults.standard.string(forKey: "joyfulText")
       
        categoryTitles=["What I Did Well", "What I'm Grateful For","Joyful Moment"]
        categoryContent=[didWellText!, gratefulText!, joyfulText!]
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let inDate=dateformatter.date(from: dateToInclude!)
        let reformattedDate=dateformatter.string(from: inDate!)
       
        myDateLabel.text=("\(reformattedDate)")
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        okButton.layer.cornerRadius = 5
        okButton.clipsToBounds = true
        
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EntryAlertCell = tableView.dequeueReusableCell(withIdentifier: "EntryAlertCell", for: indexPath) as! EntryAlertCell
        
        cell.categoryLabel.text=categoryTitles[indexPath.row]
        cell.categoryContent.text=categoryContent[indexPath.row]

        cell.selectionStyle = .none
        
        return cell
    }
    
    @IBAction func okPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
        
    }

}
