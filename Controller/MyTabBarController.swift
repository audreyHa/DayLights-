//
//  MyTabBarController.swift
//  DayLights
//
//  Created by Audrey Ha on 3/31/20.
//  Copyright © 2020 AudreyHa. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate=self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if viewController == tabBarController.viewControllers?[1]{
            var daylights=CoreDataHelper.retrieveDaylight()
            
            var count=0
            for value in daylights{
                if (value.mood != 0){
                    count+=1
                }
            }
            
            if (count<1){
                UserDefaults.standard.set("noDaylightData",forKey: "typeOKAlert")
                makeOKAlert()
                return false
            }else{
                return true
            }
        }else if viewController == tabBarController.viewControllers?[4]{
            var daylights=CoreDataHelper.retrieveDaylight()
            
            var count=0
            for value in daylights{
                if (value.mood != 0){
                    count+=1
                }
            }

            if (count>1){
                return true
            }else{
                UserDefaults.standard.set("noMoodData",forKey: "typeOKAlert")
                makeOKAlert()
                return false
            }
        }else{
            return true
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
        
        //wants to view entries
         if tabBarIndex == 1 {
             
         }
    }
    
    func makeOKAlert(){
        let vc = storyboard!.instantiateViewController(withIdentifier: "OKAlert") as! OKAlert
        var transparentGrey=UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.95)
        vc.view.backgroundColor = transparentGrey
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
}
