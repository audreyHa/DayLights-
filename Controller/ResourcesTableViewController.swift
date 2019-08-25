//
//  ResourcesTableViewController.swift
//  DayLights
//
//  Created by Audrey Ha on 4/8/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit

class ResourcesTableViewController: UITableViewController {
    
    var organizations=[Organization]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var crisisTextLine=CoreDataHelper.newOrg()
        crisisTextLine.organizationName="Crisis Text Line"
        crisisTextLine.orgDescription="Text HOME to 741-741: 24/7"
        crisisTextLine.contact=""
        organizations.append(crisisTextLine)
        
        var hopelineNetwork=CoreDataHelper.newOrg()
        hopelineNetwork.organizationName="National Hopeline Network"
        hopelineNetwork.orgDescription="Helps people dealing with depression and those thinking about suicide: 24/7"
        hopelineNetwork.contact="1-800-422-4673"
        organizations.append(hopelineNetwork)
        
        var parent=CoreDataHelper.newOrg()
        parent.organizationName="National Parent Hotline"
        parent.orgDescription="Emotional support for parents from a trained advocate: 24/7"
        parent.contact="855-427-2736"
        organizations.append(parent)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return organizations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
}
