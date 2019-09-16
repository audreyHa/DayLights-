//
//  AddContactVC.swift
//  DayLights
//
//  Created by Audrey Ha on 9/15/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Contacts

class AddContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var people=[[String]]()
    @IBOutlet weak var contactsTableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var daylightImage: UIImageView!
    @IBOutlet weak var wholeAlertView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    
    
    @IBAction func yesPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("reloadContactTBV"), object: nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        contactsTableView.delegate=self
        contactsTableView.dataSource=self
        
        headerLabel.adjustsFontSizeToFitWidth=true
        yesButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        
        yesButton.layer.cornerRadius = 5
        yesButton.clipsToBounds = true
        centerView.superview?.bringSubviewToFront(centerView)
        
        daylightImage.superview?.bringSubviewToFront(daylightImage)
        
        fetchContacts()
    }
    
    func fetchContacts(){
        print("Attempting to fetch contacts")
        
        let store=CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err=err{
                print("Failed to request access: ", err)
                return
            }
            
            if granted{
                print("Access to contacts granted")
                
                let keys=[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do{
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        var givenName=contact.givenName ?? ""
                        var familyName=contact.familyName ?? ""
                        var phoneNumber=contact.phoneNumbers.first?.value.stringValue ?? ""
                        var fullName="\(givenName) \(familyName)"
                        
                        print(givenName)
                        print(familyName)
                        print(phoneNumber)
                        
                        //COMMENT check if phone number exists in phone Core Data array. If so, don't append
                        var allContacts=CoreDataHelper.retrieveContacts()
                        var count=0
                        for oneContact in allContacts{
                            if oneContact.phoneNumber! == phoneNumber{
                                count+=1
                            }
                        }
                        
                        if count==0{
                            if givenName != ""{
                                self.people.append([fullName, contact.phoneNumbers.first?.value.stringValue ?? ""])
                            }
                        }
                        
                        
                    })
                }catch let err{
                    print("Failed to enumerate contacts:",err)
                }
                
            }else{
                print("Access to contacts denied")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people=people.sorted { $0[0] < $1[0] }
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! contactCell
        
        cell.nameLabel.adjustsFontSizeToFitWidth=true
        cell.phoneNumberLabel.adjustsFontSizeToFitWidth=true
        
        cell.nameLabel.text=people[indexPath.row][0]
        cell.phoneNumberLabel.text=people[indexPath.row][1]
        
        return cell
    }
}
