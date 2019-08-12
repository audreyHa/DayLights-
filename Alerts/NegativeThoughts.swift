//
//  NegativeThoughts.swift
//  DayLights
//
//  Created by Audrey Ha on 8/11/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class NegativeThoughts: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var thoughtsArray=[String]()
    var entriesArray=[String]()
    var allCells=[NegativeThoughtsCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thoughtsArray=["Thought 1"]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.rowHeight=UITableView.automaticDimension
        self.tableView.estimatedRowHeight=100
        
        topLabel.adjustsFontSizeToFitWidth = true
        doneButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughtsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NegativeThoughtsCell = tableView.dequeueReusableCell(withIdentifier: "NegativeThoughtsCell", for: indexPath) as! NegativeThoughtsCell
        
        cell.thoughtLabel.text="Thought \(indexPath.row+1)"
        cell.selectionStyle = .none
        cell.severeLabel.adjustsFontSizeToFitWidth=true
        cell.slider.setThumbImage(UIImage(named: "redPlayButton"), for: UIControl.State.normal)
        
        if allCells.contains(cell){
            print("this cell is already there")
        }else{
            allCells.append(cell)
        }
        
        return cell
    }
    
    @IBAction func donePressed(_ sender: Any) {
        var count=0
        for myCell in allCells{
            if myCell.detailTextLabel!.text != nil{
                count+=1
                UserDefaults.standard.set(myCell.textField!.text, forKey: "Thought \(count)")
                var sliderValue=Int(myCell.slider.value)
                UserDefaults.standard.set(sliderValue, forKey: "Slider \(count)")
            }
            
            UserDefaults.standard.set(myCell.textField!.text, forKey: "Thought \(count)")
        }
        
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addPressed(_ sender: Any) {
        var count=thoughtsArray.count+1
        thoughtsArray.append("Thought \(count)")
        tableView.reloadData()
    }
}
