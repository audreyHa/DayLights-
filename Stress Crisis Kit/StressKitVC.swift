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
    
    @IBOutlet weak var quotesTBV: UITableView!
    
    @IBOutlet weak var quotesSegmentedControl: UISegmentedControl!
    
    var organizations=[Organization]()
    var quotes=[String]()
    var authors=[String]()
    
    var savedQuotes=[String]()
    var savedAuthors=[String]()
    
    var segmentedNumber=0
    
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
        
        getRandomQuotes()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadQuotesArray(notification:)), name: Notification.Name("reloadQuotesArray"), object: nil)
    }
    
    @objc func reloadQuotesArray(notification: Notification){
        print("reloading quotes array")
        matchQuotesSegment()
    }
    
    func getRandomQuotes(){
        for i in 0...2{
            let apiToContact = "https://api.quotable.io/random"
            
            Alamofire.request(apiToContact).validate().responseJSON() { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        var randomQuoteText=json["content"]
                        var randomQuoteAuthor=json["author"]
                        
                        if randomQuoteAuthor=="Donald Trump"{
                            self.quotes.append("Do not judge me by my successes, judge me by how many times I fell down and got back up again.")
                            self.authors.append("Nelson Mandela")
                            
                            print(self.quotes)
                            self.quotesTBV.reloadData()
                        }else{
                            self.quotes.append("\(randomQuoteText)")
                            self.authors.append("\(randomQuoteAuthor)")
                            
                            print(self.quotes)
                            self.quotesTBV.reloadData()
                        }
                        
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func matchQuotesSegment(){
        if quotesSegmentedControl.selectedSegmentIndex==0{
            print("segment number is 0")
            segmentedNumber=0
        }else{
            print("segment number is 1")
            segmentedNumber=1
            
            var allSavedQuotes=CoreDataHelper.retrieveQuote()
            savedQuotes=[]
            savedAuthors=[]
            
            for savedQuote in allSavedQuotes{
                savedQuotes.append(savedQuote.quote!)
                savedAuthors.append(savedQuote.author!)
            }
        }
        
        quotesTBV.reloadData()
    }
    
    @IBAction func quotesSegmentChanged(_ sender: Any) {
        matchQuotesSegment()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == crisisTBV{
            return organizations.count
        }else if tableView==quotesTBV{
            
            if segmentedNumber==0{
                return quotes.count
            }else{
                return savedQuotes.count
            }
            
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
            cell.orgName.textColor=brightRed
            
            cell.orgName.text=organization.organizationName
            cell.orgDesc.text=organization.orgDescription
            cell.contact.text=organization.contact

            return cell
        }else if tableView==quotesTBV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCell", for: indexPath) as! quotesCell
            
            let formattedString = NSMutableAttributedString()
            
            var quoteToUse: String
            var authorToUse: String
            
            if segmentedNumber==1{
                quoteToUse=savedQuotes[indexPath.row]
                authorToUse=savedAuthors[indexPath.row]
            }else{
                quoteToUse=quotes[indexPath.row]
                authorToUse=authors[indexPath.row]
            }
            
            formattedString.normal("\(quoteToUse) -- ").bold("\(authorToUse)")
            
            cell.quotesLabel.attributedText = formattedString
            cell.quote=quoteToUse
            cell.author=authorToUse
            
            cell.bookmarkButton.setImage(UIImage(imageLiteralResourceName: "bookmark"), for: .normal)
            
            var allQuotes=CoreDataHelper.retrieveQuote()
            
            for savedQuote in allQuotes{
                if savedQuote.quote! == quoteToUse{
                    cell.bookmarkButton.setImage(UIImage(imageLiteralResourceName: "filledBookmark"), for: .normal)
                }
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCell", for: indexPath) as! quotesCell
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
