//
//  NegativeThoughtsEntering
//  DayLights
//
//  Created by Audrey Ha on 8/11/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class NegativeThoughtsEntering: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var myNegativeThoughtEntries=[NegativeThought]()
    var thoughtsArray=[String]()
    
    var entriesArray=[String]()
    var slidersArray=[Float]()
    
    var allCells=[NegativeThoughtsCell]()
    
    var firstCell: NegativeThoughtsCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thoughtsArray=["Thought 1"]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight=UITableView.automaticDimension
        self.tableView.estimatedRowHeight=100
        self.tableView.separatorStyle = .singleLine
        
        topLabel.adjustsFontSizeToFitWidth = true
        doneButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        doneButton.layer.cornerRadius=5
        
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
        
        self.hideKeyboardWhenTappedAround()
        
        myNegativeThoughtEntries=CoreDataHelper.retrieveNegativeThought()
        for entry in myNegativeThoughtEntries{
            CoreDataHelper.delete(negativeThought: entry)
        }
        CoreDataHelper.saveDaylight()
        myNegativeThoughtEntries=[]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughtsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NegativeThoughtsCell = tableView.dequeueReusableCell(withIdentifier: "NegativeThoughtsCell", for: indexPath) as! NegativeThoughtsCell
        
        cell.slider.setThumbImage(UIImage(named: "redPlayBar"), for: UIControl.State.normal)
        cell.slider.minimumValue=1
        cell.slider.maximumValue=100
        
        cell.thoughtLabel.text=thoughtsArray[indexPath.row]
        print("thoughts array: \(thoughtsArray)")
        if indexPath.row==0{
            firstCell=cell
        
            cell.textField.text=""
            cell.slider.value=1.0
            
        }else{
                if myNegativeThoughtEntries[indexPath.row-1].entry != nil{
                    cell.textField.text=myNegativeThoughtEntries[indexPath.row-1].entry
                }else{
                    cell.textField.text=""
                }
                
                if myNegativeThoughtEntries[indexPath.row-1].sliderValue != nil{
                    cell.slider.value=Float(myNegativeThoughtEntries[indexPath.row-1].sliderValue)
                }else{
                    cell.slider.value=1.0
            }
        }

        cell.selectionStyle = .none
        cell.severeLabel.adjustsFontSizeToFitWidth=true
        
        if allCells.contains(cell){
//            print("this cell is already there")
        }else{
            allCells.append(cell)
        }
        
        return cell
    }
    
    @IBAction func donePressed(_ sender: Any) {
        for entry in myNegativeThoughtEntries{
            CoreDataHelper.delete(negativeThought: entry)
        }
        
        myNegativeThoughtEntries=CoreDataHelper.retrieveNegativeThought()
        
        print("all cells count: \(allCells.count)")
        for cell in allCells{
            var newCoreDataEntry=CoreDataHelper.newNegativeThought()
            newCoreDataEntry.entry=cell.textField.text
            newCoreDataEntry.sliderValue=Int64(cell.slider.value)
            CoreDataHelper.saveDaylight()
        }
        
        myNegativeThoughtEntries=CoreDataHelper.retrieveNegativeThought()
        
        NotificationCenter.default.post(name: Notification.Name("retrieveNegativeThoughts"), object: nil)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: Any) {
        var newCoreDataEntry=CoreDataHelper.newNegativeThought()
        newCoreDataEntry.entry=firstCell!.textField.text
        newCoreDataEntry.sliderValue=Int64(firstCell!.slider.value)
        print("slider value: \(Int64(firstCell!.slider.value))")
        CoreDataHelper.saveDaylight()
        
        myNegativeThoughtEntries=CoreDataHelper.retrieveNegativeThought()
        myNegativeThoughtEntries.reverse()
        
        var count=myNegativeThoughtEntries.count+1
        thoughtsArray.insert("Thought \(count)", at: 0)
        
        print("thoughts array: \(thoughtsArray)")

        print("Negative Thought Entries count: \(myNegativeThoughtEntries.count)")
        for entry in myNegativeThoughtEntries{
            print("Text Entry: \(entry.entry!)")
        }

        tableView.reloadData()
    }
}
