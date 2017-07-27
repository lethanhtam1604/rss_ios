//
//  AcceptanceViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/2/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import SwiftOverlays
import Firebase

class AcceptanceViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let expectedStartDateHeaderView = UIView()
    let expectedStartDateHeaderLabel = UILabel()
    
    let expectedStartDateView = UIView()
    let expectedStartDateLabel = UILabel()
    let expectedStartDateArrowRightImgView = UIImageView()
    let expectedStartDateAbstractView = UIView()
    
    let descriptionHeaderView = UIView()
    let descriptionHeaderLabel = UILabel()
    
    let expectedStartTimeHeaderView = UIView()
    let expectedStartTimeHeaderLabel = UILabel()
    
    let expectedStartTimeView = UIView()
    let expectedStartTimeLabel = UITextField()
    let expectedStartTimeArrowRightImgView = UIImageView()
    let expectedStartTimeAbstractView = UIView()
    
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
        
        expectedStartDateHeaderView.backgroundColor = UIColor.clear
        expectedStartDateView.backgroundColor = UIColor.white
        descriptionHeaderView.backgroundColor = UIColor.clear
        descriptionView.backgroundColor = UIColor.white
        expectedStartTimeHeaderView.backgroundColor = UIColor.clear
        expectedStartTimeView.backgroundColor = UIColor.white
        
        expectedStartDateAbstractView.backgroundColor = UIColor.clear
        expectedStartDateAbstractView.touchHighlightingStyle = .lightBackground
        let expectedStartDateAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(expectedStartDate))
        expectedStartDateAbstractView.addGestureRecognizer(expectedStartDateAbstractViewGesture)
        
        expectedStartTimeAbstractView.backgroundColor = UIColor.clear
        expectedStartTimeAbstractView.touchHighlightingStyle = .lightBackground
        let expectedStartTimeAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(expectedStartTime))
        expectedStartTimeAbstractView.addGestureRecognizer(expectedStartTimeAbstractViewGesture)
        expectedStartTimeAbstractView.isHidden = true
        
        expectedStartDateHeaderLabel.text = "EXPECTED START DATE"
        expectedStartDateHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        expectedStartDateHeaderLabel.textAlignment = .left
        expectedStartDateHeaderLabel.textColor = Global.colorGray
        expectedStartDateHeaderLabel.numberOfLines = 1
        
        expectedStartDateLabel.text = ""
        expectedStartDateLabel.font = UIFont(name: "OpenSans", size: 15)
        expectedStartDateLabel.textAlignment = .left
        expectedStartDateLabel.textColor = UIColor.black
        expectedStartDateLabel.numberOfLines = 1
        
        expectedStartDateArrowRightImgView.clipsToBounds = true
        expectedStartDateArrowRightImgView.contentMode = .scaleAspectFit
        expectedStartDateArrowRightImgView.image = UIImage(named: "ArrowRight")
        
        expectedStartTimeHeaderLabel.text = "EXPECTED START TIME"
        expectedStartTimeHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        expectedStartTimeHeaderLabel.textAlignment = .left
        expectedStartTimeHeaderLabel.textColor = Global.colorGray
        expectedStartTimeHeaderLabel.numberOfLines = 1
        
        expectedStartTimeLabel.text = ""
        expectedStartTimeLabel.font = UIFont(name: "OpenSans", size: 15)
        expectedStartTimeLabel.textAlignment = .left
        expectedStartTimeLabel.textColor = UIColor.black
        expectedStartTimeLabel.inputView = nil
        expectedStartTimeLabel.makeTimePickerWithDoneButton()
        
        expectedStartTimeArrowRightImgView.clipsToBounds = true
        expectedStartTimeArrowRightImgView.contentMode = .scaleAspectFit
        expectedStartTimeArrowRightImgView.image = UIImage(named: "ArrowRight")
        
        
        descriptionHeaderLabel.text = "DESCRIPTION"
        descriptionHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        descriptionHeaderLabel.textAlignment = .left
        descriptionHeaderLabel.textColor = Global.colorGray
        descriptionHeaderLabel.numberOfLines = 1
        
        descriptionTV.text = ""
        descriptionTV.font = UIFont(name: "OpenSans", size: 14)
        descriptionTV.textAlignment = .left
        descriptionTV.textColor = UIColor.black
        
        expectedStartDateHeaderView.addSubview(expectedStartDateHeaderLabel)
        expectedStartDateView.addSubview(expectedStartDateLabel)
        expectedStartDateView.addSubview(expectedStartDateArrowRightImgView)
        expectedStartDateView.addSubview(expectedStartDateAbstractView)
        
        descriptionHeaderView.addSubview(descriptionHeaderLabel)
        descriptionView.addSubview(descriptionTV)
        
        expectedStartTimeHeaderView.addSubview(expectedStartTimeHeaderLabel)
        expectedStartTimeView.addSubview(expectedStartTimeLabel)
        expectedStartTimeView.addSubview(expectedStartTimeArrowRightImgView)
        expectedStartTimeView.addSubview(expectedStartTimeAbstractView)
        
        containerView.addSubview(expectedStartDateHeaderView)
        containerView.addSubview(expectedStartDateView)
        containerView.addSubview(expectedStartTimeHeaderView)
        containerView.addSubview(expectedStartTimeView)
        //        containerView.addSubview(descriptionHeaderView)
        //        containerView.addSubview(descriptionView)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    func loadData() {
        
        if UserDefaultManager.getInstance().getUserType() {
            title = "JOB #" + String(job.number!) + " (ACCEPTED)"
            expectedStartDateArrowRightImgView.isHidden = true
            expectedStartDateHeaderLabel.text = "START DATE"
            expectedStartDateLabel.text = job.accept.expectedStartDate
            expectedStartDateAbstractView.isUserInteractionEnabled = false
            
            expectedStartTimeHeaderLabel.text = "START TIME"
            expectedStartTimeLabel.text = job.accept.expectedStartTime
            expectedStartTimeLabel.isUserInteractionEnabled = false

            
            descriptionTV.text = job.accept.reason
            descriptionTV.isEditable = false
            
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                if self.job.accept.seen == false {
                    self.job.accept.seen = true
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
            title = "INVITATION"
            
            let saveBarButton = UIBarButtonItem(title: "ACCEPT", style: .done, target: self, action: #selector(accept))
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
            
            expectedStartDateHeaderView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            expectedStartDateHeaderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            expectedStartDateHeaderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            expectedStartDateHeaderView.autoSetDimension(.height, toSize: height)
            
            expectedStartDateHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            expectedStartDateHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            expectedStartDateHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            expectedStartDateHeaderLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------
            
            expectedStartDateView.autoPinEdge(.top, to: .bottom, of: expectedStartDateHeaderView)
            expectedStartDateView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            expectedStartDateView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            expectedStartDateView.autoSetDimension(.height, toSize: height)
            
            expectedStartDateLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            expectedStartDateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            expectedStartDateLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            expectedStartDateLabel.autoSetDimension(.height, toSize: 20)
            
            expectedStartDateArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            expectedStartDateArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            expectedStartDateArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            expectedStartDateAbstractView.autoPinEdgesToSuperviewEdges()
            
            //------------------------------------------------------------------------
            
            expectedStartTimeHeaderView.autoPinEdge(.top, to: .bottom, of: expectedStartDateView)
            expectedStartTimeHeaderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            expectedStartTimeHeaderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            expectedStartTimeHeaderView.autoSetDimension(.height, toSize: height)
            
            expectedStartTimeHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            expectedStartTimeHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            expectedStartTimeHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            expectedStartTimeHeaderLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------
            
            expectedStartTimeView.autoPinEdge(.top, to: .bottom, of: expectedStartTimeHeaderView)
            expectedStartTimeView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            expectedStartTimeView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            expectedStartTimeView.autoSetDimension(.height, toSize: height)
            
            expectedStartTimeLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            expectedStartTimeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            expectedStartTimeLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            expectedStartTimeLabel.autoSetDimension(.height, toSize: 20)
            
            expectedStartTimeArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            expectedStartTimeArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            expectedStartTimeArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            expectedStartTimeAbstractView.autoPinEdgesToSuperviewEdges()
            
            //------------------------------------------------------------------------
            
            //            descriptionHeaderView.autoPinEdge(.top, to: .bottom, of: expectedStartDateView)
            //            descriptionHeaderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            //            descriptionHeaderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            //            descriptionHeaderView.autoSetDimension(.height, toSize: height)
            //
            //            descriptionHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            //            descriptionHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            //            descriptionHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            //            descriptionHeaderLabel.autoSetDimension(.height, toSize: 20)
            //
            //            //------------------------------------------------------------------------
            //
            //            descriptionView.autoPinEdge(.top, to: .bottom, of: descriptionHeaderView)
            //            descriptionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            //            descriptionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            //            descriptionView.autoSetDimension(.height, toSize: 100)
            //
            //            descriptionTV.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            //            descriptionTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            //            descriptionTV.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            //            descriptionTV.autoSetDimension(.height, toSize: 80)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 210
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    var fromDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "MM-dd-yyyy"
            
            if fromDate != nil {
                expectedStartDateLabel.text = dateFormatter.string(from: fromDate! as Date)
            } else {
                
            }
        }
    }
    
    
    func expectedStartDate() {
        var date = NSDate()
        if(fromDate != nil) {
            date = fromDate!
        }
        
        var datePickerViewController : UIViewController!
        datePickerViewController = AIDatePickerController.picker(with: date as Date!, selectedBlock: {
            newDate in
            self.fromDate = newDate as NSDate?
            datePickerViewController.dismiss(animated: true, completion: nil)
        }, cancel: {
            datePickerViewController.dismiss(animated: true, completion: nil)
        }) as! UIViewController
        
        datePickerViewController.view.tintColor = Global.colorSignin
        
        present(datePickerViewController, animated: true, completion: nil)
    }
    
    func expectedStartTime() {
        
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    var isSaving = false
    
    func accept() {
        
        if isSaving {
            return
        }
        
        if expectedStartDateLabel.text == "" {
            Utils.showAlert(title: "Error", message: "Expected start date can not be empty!", viewController: self)
            return
        }
        
        if expectedStartTimeLabel.text == "" {
            Utils.showAlert(title: "Error", message: "Expected start time can not be empty!", viewController: self)
            return
        }
        
        //        if descriptionTV.text == "" {
        //            Utils.showAlert(title: "Error", message: "Description can not be empty!", viewController: self)
        //            return
        //        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let currentDate = dateFormatter.date(from: expectedStartDateLabel.text!)
        
        let previousDate = dateFormatter.date(from: job.assign.acceptanceDate!)
        
        if (currentDate?.isLessThanDate(dateToCompare: previousDate!))! {
            Utils.showAlert(title: "Error", message: "Expected Start Data should be greater than Acceptance Date", viewController: self)
            return
        }
        
        isSaving = true
        
        job.accept.expectedStartDate = expectedStartDateLabel.text
        job.accept.expectedStartTime = expectedStartTimeLabel.text
        job.accept.reason = descriptionTV.text
        job.assignmentStatus = 2
        job.jobStatus = JobStatus.Schedule.rawValue
        job.accept.seen = false
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            if user != nil {
                
                let message = Message()
                message.title = (user?.name)! + "accepted the job #" + String(self.job.number!)
                message.body = " - EXPECTED START DATE: " + self.job.accept.expectedStartDate! + "\n- EXPECTED START TIME: " + self.job.accept.expectedStartTime!
                
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
