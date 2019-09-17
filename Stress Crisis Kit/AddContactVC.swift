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
    
    var navyBlue: UIColor!
    var mediumBlue: UIColor!
    
    @IBAction func yesPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("reloadContactTBV"), object: nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        navyBlue=UIColor(rgb: 0x285C95)
        mediumBlue=UIColor(rgb: 0x1fc2ff)
        
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
    }

    
    override func viewDidAppear(_ animated: Bool) {
        fetchContacts()
    }
    
    func fetchContacts(){
        print("Attempting to fetch contacts")
        let store=CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
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
                        if (givenName != "")&&(phoneNumber != ""){
                            self.people.append([fullName, contact.phoneNumbers.first?.value.stringValue ?? ""])
                        }
                    }
                    
                    self.contactsTableView.reloadData()
                })
            }catch let err{
                print("Failed to enumerate contacts:",err)
            }
        case .denied:
            DispatchQueue.main.async {
                UserDefaults.standard.set("contactsNoAccess",forKey: "typeOKAlert")
                self.makeOKAlert()
            }
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    //user granted access to contacts
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
                                if (givenName != "")&&(phoneNumber != ""){
                                    self.people.append([fullName, contact.phoneNumbers.first?.value.stringValue ?? ""])
                                }
                            }
                            DispatchQueue.main.async {
                                self.contactsTableView.reloadData()
                            }
                        })
                    }catch let err{
                        print("Failed to enumerate contacts:",err)
                    }
                } else {
                    //user did not grant access to contacts, so going back to Stress Crisis Kit
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("contactsNoAccess",forKey: "typeOKAlert")
                        self.makeOKAlert()
                    }
                    
                }
            }
        }
        
    }

    func makeOKAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "OKAlert") as! OKAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
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
        
        cell.addButton.titleLabel?.textColor=UIColor.black
        cell.addButton.backgroundColor=mediumBlue
        cell.addButton.setTitle("Add", for: .normal)
        
        var allSavedPeople=CoreDataHelper.retrieveContacts()
        for people in allSavedPeople{
            if people.phoneNumber==cell.phoneNumberLabel.text{
                cell.addButton.titleLabel?.textColor=UIColor.white
                cell.addButton.backgroundColor=navyBlue
                cell.addButton.setTitle(" Added ", for: .normal)
            }
        }
        
        return cell
    }
}

extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
}
