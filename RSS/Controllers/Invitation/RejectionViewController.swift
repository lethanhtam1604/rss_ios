//
//  RejectionViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/3/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import SwiftOverlays
import Firebase

class RejectionViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let descriptionHeaderView = UIView()
    let descriptionHeaderLabel = UILabel()
    
    let descriptionView = UIView()
    let descriptionTV = UITextView()
    
    var constraintsAdded = false
    
    var job = Job()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        descriptionHeaderView.backgroundColor = UIColor.clear
        descriptionView.backgroundColor = UIColor.white
        
        descriptionHeaderLabel.text = "Why do you reject this job?"
        descriptionHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        descriptionHeaderLabel.textAlignment = .left
        descriptionHeaderLabel.textColor = UIColor.black
        descriptionHeaderLabel.numberOfLines = 1
        
        descriptionTV.text = ""
        descriptionTV.font = UIFont(name: "OpenSans", size: 14)
        descriptionTV.textAlignment = .left
        descriptionTV.textColor = UIColor.black
        
        descriptionHeaderView.addSubview(descriptionHeaderLabel)
        descriptionView.addSubview(descriptionTV)
        
        containerView.addSubview(descriptionHeaderView)
        containerView.addSubview(descriptionView)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    func loadData() {
        if UserDefaultManager.getInstance().getUserType() {
            title = "JOB #" + String(job.number!) + " (REJECTED)"
            descriptionTV.text = job.reject.reason
            descriptionTV.isEditable = false
            
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                if self.job.reject.seen == false {
                    self.job.reject.seen = true
                    DatabaseHelper.shared.saveJob(userId: (FIRAuth.auth()?.currentUser?.uid)!, job: self.job) {_ in 
                        
                    }
                    let badge = (user?.totalBadge)! - 1
                    user?.totalBadge = badge
                    DatabaseHelper.shared.saveUser(user: user!) {
                        
                    }
                }
            }
        }
        else {
            
            title = "REJECTION"
            
            let saveBarButton = UIBarButtonItem(title: "REJECT", style: .done, target: self, action: #selector(reject))
            saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin,NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
            self.navigationItem.rightBarButtonItem = saveBarButton
            
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                if self.job.invitationSeen == false {
                    self.job.invitationSeen = true
                    
                    DatabaseHelper.shared.saveJob(userId: (user?.adminId)!, job: self.job) {_ in 
                        
                    }
                    
                    let badge = (user?.totalBadge)! - 1
                    user?.totalBadge = badge
                    DatabaseHelper.shared.saveUser(user: user!) {
                        
                    }
                }
            }
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: view)
            
            
            let height: CGFloat = 50
            
            //------------------------------------------------------------------------
            
            descriptionHeaderView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            descriptionHeaderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            descriptionHeaderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            descriptionHeaderView.autoSetDimension(.height, toSize: height)
            
            descriptionHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            descriptionHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            descriptionHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            descriptionHeaderLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------
            
            descriptionView.autoPinEdge(.top, to: .bottom, of: descriptionHeaderView)
            descriptionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            descriptionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            descriptionView.autoSetDimension(.height, toSize: 100)
            
            descriptionTV.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            descriptionTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            descriptionTV.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            descriptionTV.autoSetDimension(.height, toSize: 80)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 150
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    var isSaving = false
    
    func reject() {
        
        if isSaving {
            return
        }
        
        if descriptionTV.text == "" {
            Utils.showAlert(title: "Error", message: "Reason can not be empty!", viewController: self)
            return
        }
        
        isSaving = true
        
        job.reject.reason = descriptionTV.text
        job.assignmentStatus = 3
        job.reject.seen = false
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            if user != nil {
                
                let message = Message()
                message.title = (user?.name)! + " rejected the job #" + String(self.job.number!)
                message.body = " - Reason: " + self.job.reject.reason!
                
                DatabaseHelper.shared.sendMessage(userId: (user?.adminId)!, message: message) {
                    _ in
                    
                }
                
                DatabaseHelper.shared.getUser(id: (user?.adminId)!) {
                    adminUser in
                    let badge = (adminUser?.totalBadge)! + 1
                    adminUser?.totalBadge = badge
                    DatabaseHelper.shared.saveUser(user: adminUser!) {
                        
                    }
                }
                
                DatabaseHelper.shared.saveJob(userId: (user?.adminId)!, job: self.job) {_ in 
                    SwiftOverlays.removeAllBlockingOverlays()
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                self.isSaving = false
                Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
            }
        }
        
    }
}
