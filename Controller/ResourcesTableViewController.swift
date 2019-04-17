//
//  ResourcesTableViewController.swift
//  DayLights
//
//  Created by Audrey Ha on 4/8/19.
//  Copyright © 2019 AudreyHa. All rights reserved.
//

import UIKit
import Crashlytics

class ResourcesTableViewController: UITableViewController {
    
    var organizations=[Organization]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEvent(withName: "Opened Resources", customAttributes: nil)
        var crisisTextLine=CoreDataHelper.newOrg()
        crisisTextLine.organizationName="Crisis Text Line"
        crisisTextLine.orgDescription="Text HOME to 741-741: 24/7"
        crisisTextLine.contact=""
        organizations.append(crisisTextLine)

        var domesticViolence=CoreDataHelper.newOrg()
        domesticViolence.organizationName="National Domestic Violence Hotline"
        domesticViolence.orgDescription="Crisis intervention, safety planning, and information on domestic violence: 24/7"
        domesticViolence.contact="1-800-799-7233"
        organizations.append(domesticViolence)
        
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
        
        var selfHarmHotline=CoreDataHelper.newOrg()
        selfHarmHotline.organizationName="Self-harm Hotline"
        selfHarmHotline.orgDescription="Provides services to adolesecents and adults engaging in self-destructive behaviors: 24/7"
        selfHarmHotline.contact="1-800-366-8288"
        organizations.append(selfHarmHotline)
        
        var sexualAssaultHotline=CoreDataHelper.newOrg()
        sexualAssaultHotline.organizationName="National Sexual Assault Hotline"
        sexualAssaultHotline.orgDescription="Ran by RAINN (Rape, Abuse, and Incest National Network): 24/7"
        sexualAssaultHotline.contact="1-800-656-4673"
        organizations.append(sexualAssaultHotline)

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
        
        var veteran=CoreDataHelper.newOrg()
        veteran.organizationName="Veteran Crisis Line"
        veteran.orgDescription="Talk to a caring crisis hotline volunteer: 24/7"
        veteran.contact="877-838-2838"
        organizations.append(veteran)
        
        var anxiety=CoreDataHelper.newOrg()
        anxiety.organizationName="Anxiety and Depression Association of America"
        anxiety.orgDescription="Information of prevention, treatment, and symptoms of anxiety and depression"
        anxiety.contact="240-485-1001"
        organizations.append(anxiety)
        
        var depressionBi=CoreDataHelper.newOrg()
        depressionBi.organizationName="Depression and Bipolar Support Alliance"
        depressionBi.orgDescription="Information on bipolar disorder and depression, in-person and online support"
        depressionBi.contact="1-800-826-3632"
        organizations.append(depressionBi)
        
        var sidran=CoreDataHelper.newOrg()
        sidran.organizationName="Sidran Institute"
        sidran.orgDescription="Understand, manage, and treat trauma and dissociation"
        sidran.contact="410-825-8888 ext 102"
        organizations.append(sidran)
        
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
