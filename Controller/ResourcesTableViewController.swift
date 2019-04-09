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
        
        var anxiety=CoreDataHelper.newOrg()
        anxiety.organizationName="Anxiety and Depression Association of America"
        anxiety.orgDescription="Info of prevention, treatment, and symptoms of anxiety and depression"
        anxiety.contact="240-485-1001"
        organizations.append(anxiety)
        
        var depressionBi=CoreDataHelper.newOrg()
        depressionBi.organizationName="Depression and Bipolar Support Alliance"
        depressionBi.orgDescription="Info on bipolar disorder and depression, in-person and online support"
        depressionBi.contact="1-800-826-3632"
        organizations.append(depressionBi)
        
        var domesticViolence=CoreDataHelper.newOrg()
        domesticViolence.organizationName="National Domestic Violence Hotline"
        domesticViolence.orgDescription="Crisis intervention, safety planning and information on domestic violence: 24/7"
        domesticViolence.contact="1-800-799-7233"
        organizations.append(domesticViolence)
        
        var sidran=CoreDataHelper.newOrg()
        sidran.organizationName="Sidran Institute"
        sidran.orgDescription="Understand, manage, and treat trauma"
        sidran.contact="410-825-8888"
        organizations.append(sidran)
        
        var mentalAndSubstance=CoreDataHelper.newOrg()
        mentalAndSubstance.organizationName="Substance Abuse and Mental Health Services Administration"
        mentalAndSubstance.orgDescription="Mental and/or substance use disorders national helpline: 24/7"
        mentalAndSubstance.contact="1-800-662-4357"
        organizations.append(mentalAndSubstance)
        
        var suicidePrevent=CoreDataHelper.newOrg()
        suicidePrevent.organizationName="Suicide Prevention Lifeline"
        suicidePrevent.orgDescription="Connects callers to trained crisis counselors: 24/7"
        suicidePrevent.contact="1-800-273-8255"
        organizations.append(suicidePrevent)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationCell", for: indexPath) as! OrganizationCell

        let organization=self.organizations[indexPath.row]
        
        cell.orgName.text=organization.organizationName
        cell.orgDesc.text=organization.orgDescription
        cell.contact.text=organization.contact
        
        return cell
    }
    
}
