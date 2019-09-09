//
//  StressKitVC.swift
//  DayLights
//
//  Created by Audrey Ha on 9/8/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StressKitVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var phoneNumbersTBV: UITableView!
    @IBOutlet weak var crisisTBV: UITableView!
    var organizations=[Organization]()
    var quotes=[String]()
    var authors=[String]()
    @IBOutlet weak var quotesTBV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.crisisTBV.estimatedRowHeight = 80
        self.crisisTBV.rowHeight = UITableView.automaticDimension
        
        crisisTBV.layer.cornerRadius=10
        crisisTBV.delegate=self
        crisisTBV.dataSource=self
        crisisTBV.allowsSelection=false
        
        self.quotesTBV.estimatedRowHeight = 80
        self.quotesTBV.rowHeight = UITableView.automaticDimension
        
        quotesTBV.layer.cornerRadius=10
        quotesTBV.delegate=self
        quotesTBV.dataSource=self
        quotesTBV.allowsSelection=false
        
        if(UserDefaults.standard.bool(forKey: "setUpOrganizations")==false){
            var crisisTextLine=CoreDataHelper.newOrg()
            crisisTextLine.organizationName="Crisis Text Line"
            crisisTextLine.orgDescription="Text HOME to 741-741: 24/7"
            crisisTextLine.contact=""
            
            var hopelineNetwork=CoreDataHelper.newOrg()
            hopelineNetwork.organizationName="National Hopeline Network"
            hopelineNetwork.orgDescription="Helps people dealing with depression and those thinking about suicide: 24/7"
            hopelineNetwork.contact="1-800-422-4673"
            
            
            var parent=CoreDataHelper.newOrg()
            parent.organizationName="National Parent Hotline"
            parent.orgDescription="Emotional support for parents from a trained advocate: 24/7"
            parent.contact="855-427-2736"
            
            CoreDataHelper.saveDaylight()
            
            UserDefaults.standard.set(true, forKey: "setUpOrganizations")
        }
        
        organizations=CoreDataHelper.retrieveOrg()
        
        let apiToContact = "https://api.quotable.io/quotes"

        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for i in 0...19{
                        var randomQuoteData=json["results"][i]
                        var randomQuoteText=randomQuoteData["content"]
                        var randomQuoteAuthor=randomQuoteData["author"]
                        
                        self.quotes.append("\(randomQuoteText)")
                        self.authors.append("\(randomQuoteAuthor)")

                        print("appending quote \(self.quotes.count)")
                    }

                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        quotesTBV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == crisisTBV{
            return organizations.count
        }else if tableView==quotesTBV{
            return quotes.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == crisisTBV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationCell", for: indexPath) as! OrganizationCell

            let organization=self.organizations[indexPath.row]
            var brightRed = UIColor(red: 232.0/255.0, green: 90.0/255.0, blue: 69.0/255.0, alpha: 1.0)
            var teal = UIColor(red: 41.0/255.0, green: 220.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            if (organization.organizationName=="Anxiety and Depression Association of America")||(organization.organizationName=="Depression and Bipolar Support Alliance")||(organization.organizationName=="Sidran Institute"){
                cell.orgName.textColor=teal
            }else{
                cell.orgName.textColor=brightRed
            }
            cell.orgName.text=organization.organizationName
            cell.orgDesc.text=organization.orgDescription
            cell.contact.text=organization.contact

            return cell
        }else if tableView==quotesTBV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCell", for: indexPath) as! quotesCell
            print("Index Path: \(indexPath.row)")
            
            let formattedString = NSMutableAttributedString()
            formattedString.normal("\(quotes[indexPath.row]) -- ").bold("\(authors[indexPath.row])")
            
            
            cell.quotesLabel.text="\(quotes[indexPath.row]) -- \(authors[indexPath.row])"
            
            cell.quotesLabel.attributedText = formattedString
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCell", for: indexPath) as! quotesCell
            print("Index Path: \(indexPath.row)")

            let formattedString = NSMutableAttributedString()
            formattedString.normal("\(quotes[indexPath.row]) -- ").bold("\(authors[indexPath.row])")
            
            
            cell.quotesLabel.text="\(quotes[indexPath.row]) -- \(authors[indexPath.row])"
            
            cell.quotesLabel.attributedText = formattedString
            return cell
        }
    }

}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        var darkBlue=UIColor(rgb: 0x007ebd)
        
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 19)!,
                                                    .foregroundColor: UIColor(cgColor: darkBlue.cgColor)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
