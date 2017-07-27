//
//  MainViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 22/03/17.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Firebase

class MainViewController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {
    
    let gradientView = GradientView()
    static var jobViewController = JobViewController()
    static var staffViewController = StaffViewController()
    static var clientViewController = ClientViewController()
    static var settingViewController = SettingViewController()
    
    static var myJobViewController = MyJobViewController()
    static var invitationViewController = InvitationViewController()
    
    var jobImage: UIImage!
    var staffImage: UIImage!
    var clientImage: UIImage!
    var settingImage: UIImage!
    var invitationImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = Global.colorSignin
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = UIColor.white
        tabBar.backgroundImage = UIImage()
        tabBar.isTranslucent = false
        
        let attributesNormal = [NSForegroundColorAttributeName: Global.colorGray, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10)!]
        let attributesSelected = [NSForegroundColorAttributeName: Global.colorSignin, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10)!]

        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
        MainViewController.jobViewController = JobViewController()
        MainViewController.staffViewController = StaffViewController()
        MainViewController.clientViewController = ClientViewController()
        MainViewController.settingViewController = SettingViewController()
        
        MainViewController.myJobViewController = MyJobViewController()
        MainViewController.invitationViewController = InvitationViewController()

        jobImage = UIImage(named: "Job")
        staffImage = UIImage(named: "Staff")
        clientImage = UIImage(named: "Client")
        settingImage = UIImage(named: "Setting")
        invitationImage = UIImage(named: "Invitation")
        
        if UserDefaultManager.getInstance().getUserType() {
            let jobBarItem = UITabBarItem(title: "JOBS", image: jobImage, tag: 1)
            MainViewController.jobViewController.tabBarItem = jobBarItem
            let nc1 = UINavigationController(rootViewController: MainViewController.jobViewController)
            
            let staffBarItem = UITabBarItem(title: "STAFF", image: staffImage, tag: 2)
            MainViewController.staffViewController.tabBarItem = staffBarItem
            let nc2 = UINavigationController(rootViewController: MainViewController.staffViewController)
            
            let clientBarItem = UITabBarItem(title: "CLIENTS", image: clientImage, tag: 3)
            MainViewController.clientViewController.tabBarItem = clientBarItem
            let nc3 = UINavigationController(rootViewController: MainViewController.clientViewController)
            
            let settingBarItem = UITabBarItem(title: "SETTINGS", image: settingImage, tag: 4)
            MainViewController.settingViewController.tabBarItem = settingBarItem
            let nc4 = UINavigationController(rootViewController: MainViewController.settingViewController)
            
            self.viewControllers = [nc1, nc2, nc3, nc4]
            
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                
                let badge = (user?.totalBadge)!
                Utils.setBadgeIndicator(badgeCount: badge)
                
                // observe
                DatabaseHelper.shared.observeUsers() {
                    newUser in
                    if newUser.id == (FIRAuth.auth()?.currentUser?.uid)! {
                        let badge = (newUser.totalBadge)!
                        Utils.setBadgeIndicator(badgeCount: badge)
                    }
                }
            }
        }
        else {
            let myJobBarItem = UITabBarItem(title: "MY JOBS", image: jobImage, tag: 1)
            MainViewController.myJobViewController.tabBarItem = myJobBarItem
            let nc1 = UINavigationController(rootViewController: MainViewController.myJobViewController)
            
            let invitationBarItem = UITabBarItem(title: "INVITATION", image: clientImage, tag: 2)
            MainViewController.invitationViewController.tabBarItem = invitationBarItem
            let nc2 = UINavigationController(rootViewController: MainViewController.invitationViewController)
            
            let settingBarItem = UITabBarItem(title: "SETTINGS", image: settingImage, tag: 3)
            MainViewController.settingViewController.tabBarItem = settingBarItem
            let nc3 = UINavigationController(rootViewController: MainViewController.settingViewController)
            
            self.viewControllers = [nc1, nc2, nc3]
            
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                
                let badge = (user?.totalBadge)!
                Utils.setBadgeIndicatorForStaff(badgeCount: badge)
                
                // observe
                DatabaseHelper.shared.observeUsers() {
                    newUser in
                    if newUser.id == (FIRAuth.auth()?.currentUser?.uid)! {
                        let badge = (newUser.totalBadge)!
                        Utils.setBadgeIndicatorForStaff(badgeCount: badge)
                    }
                }
            }
        }
    }
}
