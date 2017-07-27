//
//  SettingViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/22/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, AlertDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let profileView = UIView()
    let profileIconImgView = UIImageView()
    let profileLabel = UILabel()
    let profileArrowRightImgView = UIImageView()
    let profileAbstractView = UIView()
    let profileBorderView = UIView()
    let profileBorderAboveView = UIView()
    
    let logoutView = UIView()
    let logoutIconImgView = UIImageView()
    let logoutLabel = UILabel()
    let logoutAbstractView = UIView()
    
    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.clipsToBounds = true
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = Global.colorSignin
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        title = "SETTINGS"
        
        profileView.backgroundColor = UIColor.white
        logoutView.backgroundColor = UIColor.white
        
        profileAbstractView.backgroundColor = UIColor.clear
        profileAbstractView.touchHighlightingStyle = .lightBackground
        let profileAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(profile))
        profileAbstractView.addGestureRecognizer(profileAbstractViewGesture)
        
        logoutAbstractView.backgroundColor = UIColor.clear
        logoutAbstractView.touchHighlightingStyle = .lightBackground
        let logoutAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(logout))
        logoutAbstractView.addGestureRecognizer(logoutAbstractViewGesture)
        
        profileLabel.text = "Profile"
        profileLabel.font = UIFont(name: "OpenSans-semibold", size: 17)
        profileLabel.textAlignment = .left
        profileLabel.textColor = UIColor.black
        profileLabel.numberOfLines = 1
        
        profileArrowRightImgView.clipsToBounds = true
        profileArrowRightImgView.contentMode = .scaleAspectFit
        profileArrowRightImgView.image = UIImage(named: "ArrowRight")
        
        profileIconImgView.clipsToBounds = true
        profileIconImgView.contentMode = .scaleAspectFit
        profileIconImgView.image = UIImage(named: "User")
        
        profileBorderView.backgroundColor = Global.colorSeparator
        profileBorderAboveView.backgroundColor = Global.colorSeparator
        
        logoutLabel.text = "Logout"
        logoutLabel.font = UIFont(name: "OpenSans-semibold", size: 17)
        logoutLabel.textAlignment = .left
        logoutLabel.textColor = Global.colorSignin
        logoutLabel.numberOfLines = 1
        
        logoutIconImgView.clipsToBounds = true
        logoutIconImgView.contentMode = .scaleAspectFit
        logoutIconImgView.image = UIImage(named: "Logout")
        
        profileView.addSubview(profileLabel)
        profileView.addSubview(profileArrowRightImgView)
        profileView.addSubview(profileIconImgView)
        profileView.addSubview(profileAbstractView)
        profileView.addSubview(profileBorderView)
        profileView.addSubview(profileBorderAboveView)
        
        logoutView.addSubview(logoutLabel)
        logoutView.addSubview(logoutIconImgView)
        logoutView.addSubview(logoutAbstractView)
        
        containerView.addSubview(profileView)
        containerView.addSubview(logoutView)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: view)
            
            let height: CGFloat = 60
            
            //------------------------------------------------------------------------
            
            profileView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            profileView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            profileView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            profileView.autoSetDimension(.height, toSize: height)
            
            profileIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            profileIconImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            profileIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            profileLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            profileLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            profileLabel.autoPinEdge(.left, to: .right, of: profileIconImgView, withOffset: 10)
            profileLabel.autoPinEdge(.right, to: .left, of: profileArrowRightImgView, withOffset: -10)
            
            profileArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
            profileArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            profileArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            profileBorderAboveView.autoPinEdge(toSuperviewEdge: .top)
            profileBorderAboveView.autoPinEdge(toSuperviewEdge: .right)
            profileBorderAboveView.autoPinEdge(toSuperviewEdge: .left)
            profileBorderAboveView.autoSetDimension(.height, toSize: 0.5)
            
            profileBorderView.autoPinEdge(toSuperviewEdge: .bottom)
            profileBorderView.autoPinEdge(toSuperviewEdge: .right)
            profileBorderView.autoPinEdge(toSuperviewEdge: .left)
            profileBorderView.autoSetDimension(.height, toSize: 0.5)
            
            profileAbstractView.autoPinEdgesToSuperviewEdges()
            
            //------------------------------------------------------------------------
            
            logoutView.autoPinEdge(.top, to: .bottom, of: profileView, withOffset: 0)
            logoutView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            logoutView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            logoutView.autoSetDimension(.height, toSize: height)
            
            logoutIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            logoutIconImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            logoutIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            logoutLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            logoutLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            logoutLabel.autoPinEdge(.left, to: .right, of: logoutIconImgView, withOffset: 10)
            logoutLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            
            logoutAbstractView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 120
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func profile() {
        var viewController: UIViewController!
        
        if UserDefaultManager.getInstance().getUserType() == true {
            viewController = AdminProfileViewController()
        }
        else {
            viewController = StaffProfileViewController()
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func logout() {
        Utils.showAlertAction(title: "Logout", message: "Are you sure want to logout?", viewController: self, alertDelegate: self)
    }
    
    func okAlertActionClicked() {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/" + (FIRAuth.auth()?.currentUser?.uid)!)
                try FIRAuth.auth()?.signOut()
                Utils.setBadgeIndicator(badgeCount: 0)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = SignInViewController()
                
            }
            catch let error as NSError {
                Utils.showAlertAction(title: "Logout", message: error.localizedDescription, viewController: self, alertDelegate: self)
            }
        }
        else {
            Utils.showAlertAction(title: "Logout", message: "Logout error. Please try again!", viewController: self, alertDelegate: self)
        }
    }
}
