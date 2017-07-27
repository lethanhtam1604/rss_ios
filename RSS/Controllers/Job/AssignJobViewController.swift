//
//  AssignJobViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/27/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import Firebase
import SwiftOverlays

protocol AssignJobDelegate {
    func saveAssignJob(assign: Assign)
}

class AssignJobViewController: UIViewController, AssignToDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let staffMemberView = UIView()
    let staffMemberLabel = UILabel()
    
    let staffMembrValueView = UIView()
    let staffMemberValueField = UITextField()
    let staffMemberArrowRightImgView = UIImageView()
    let staffMemberValueAbstractView = UIView()
    
    let acceptanceDateView = UIView()
    let acceptanceDateLabel = UILabel()
    
    let acceptanceDateValueView = UIView()
    let acceptanceDateValueField = UITextField()
    let acceptanceDateArrowRightImgView = UIImageView()
    let acceptanceDateArrowRightAbstractView = UIView()
    
    var constraintsAdded = false
    
    var assignJobDelegate: AssignJobDelegate!
    
    var staff: User!
    var assign = Assign()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.addTapToDismiss()
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = Global.colorSignin
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        title = "ASSIGN JOB"
        
        let cancelBarButton = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(cancel))
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        let assignBarButton = UIBarButtonItem(title: "ASSIGN", style: .done, target: self, action: #selector(saveAssign))
        assignBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = assignBarButton
        
        staffMemberView.backgroundColor = UIColor.clear
        staffMembrValueView.backgroundColor = UIColor.white
        acceptanceDateView.backgroundColor = UIColor.clear
        acceptanceDateValueView.backgroundColor = UIColor.white
        
        staffMemberValueAbstractView.backgroundColor = UIColor.clear
        staffMemberValueAbstractView.touchHighlightingStyle = .lightBackground
        let staffMemberAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(staffMember))
        staffMemberValueAbstractView.addGestureRecognizer(staffMemberAbstractViewGesture)
        
        acceptanceDateArrowRightAbstractView.backgroundColor = UIColor.clear
        acceptanceDateArrowRightAbstractView.touchHighlightingStyle = .lightBackground
        let acceptanceDateAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(acceptanceDate))
        acceptanceDateArrowRightAbstractView.addGestureRecognizer(acceptanceDateAbstractViewGesture)
        
        staffMemberLabel.text = "STAFF MEMBER"
        staffMemberLabel.font = UIFont(name: "OpenSans", size: 15)
        staffMemberLabel.textAlignment = .left
        staffMemberLabel.textColor = Global.colorGray
        staffMemberLabel.numberOfLines = 1
        
        staffMemberValueField.textAlignment = .left
        staffMemberValueField.placeholder = "Enter Staff Member"
        staffMemberValueField.textColor = UIColor.black
        staffMemberValueField.returnKeyType = .go
        staffMemberValueField.keyboardType = .namePhonePad
        staffMemberValueField.inputAccessoryView = UIView()
        staffMemberValueField.autocorrectionType = .no
        staffMemberValueField.autocapitalizationType = .none
        staffMemberValueField.font = UIFont(name: "OpenSans", size: 17)
        staffMemberValueField.isUserInteractionEnabled = false
        
        acceptanceDateLabel.text = "ACCEPT BY"
        acceptanceDateLabel.font = UIFont(name: "OpenSans", size: 15)
        acceptanceDateLabel.textAlignment = .left
        acceptanceDateLabel.textColor = Global.colorGray
        acceptanceDateLabel.numberOfLines = 1
        
        acceptanceDateValueField.textAlignment = .left
        acceptanceDateValueField.placeholder = "Enter Accepttance Date"
        acceptanceDateValueField.textColor = UIColor.black
        acceptanceDateValueField.returnKeyType = .go
        acceptanceDateValueField.keyboardType = .namePhonePad
        acceptanceDateValueField.inputAccessoryView = UIView()
        acceptanceDateValueField.autocorrectionType = .no
        acceptanceDateValueField.autocapitalizationType = .none
        acceptanceDateValueField.font = UIFont(name: "OpenSans", size: 17)
        acceptanceDateValueField.isUserInteractionEnabled = false
        
        staffMemberArrowRightImgView.clipsToBounds = true
        staffMemberArrowRightImgView.contentMode = .scaleAspectFit
        staffMemberArrowRightImgView.image = UIImage(named: "ArrowRight")
        
        acceptanceDateArrowRightImgView.clipsToBounds = true
        acceptanceDateArrowRightImgView.contentMode = .scaleAspectFit
        acceptanceDateArrowRightImgView.image = UIImage(named: "ArrowRight")
        
        staffMemberView.addSubview(staffMemberLabel)
        staffMembrValueView.addSubview(staffMemberValueField)
        staffMembrValueView.addSubview(staffMemberArrowRightImgView)
        staffMembrValueView.addSubview(staffMemberValueAbstractView)
        
        acceptanceDateView.addSubview(acceptanceDateLabel)
        acceptanceDateValueView.addSubview(acceptanceDateArrowRightImgView)
        acceptanceDateValueView.addSubview(acceptanceDateArrowRightAbstractView)
        acceptanceDateValueView.addSubview(acceptanceDateValueField)
        
        containerView.addSubview(staffMemberView)
        containerView.addSubview(staffMembrValueView)
        containerView.addSubview(acceptanceDateView)
        containerView.addSubview(acceptanceDateValueView)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    func loadData() {
        
        DatabaseHelper.shared.getUser(id: self.assign.staffId ?? "") {
            newStaff in
            if newStaff != nil {
                self.staff = newStaff
                self.staffMemberValueField.text = self.staff.name
            }
        }
        
        DatabaseHelper.shared.observeUsers() {
            newStaff in
            if (newStaff.id == self.assign.staffId) {
                self.staff = newStaff
                self.staffMemberValueField.text = self.staff.name
            }
        }
        
        acceptanceDateValueField.text = assign.acceptanceDate ?? ""
        
        if self.acceptanceDateValueField.text != "" {            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "MM-dd-yyyy"
            
            fromDate = dateFormatter.date(from: acceptanceDateValueField.text!) as NSDate?
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
            
            staffMemberView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            staffMemberView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            staffMemberView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            staffMemberView.autoSetDimension(.height, toSize: height)
            
            staffMemberLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            staffMemberLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            staffMemberLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            staffMemberLabel.autoSetDimension(.height, toSize: 20)
            
            staffMembrValueView.autoPinEdge(.top, to: .bottom, of: staffMemberView)
            staffMembrValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            staffMembrValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            staffMembrValueView.autoSetDimension(.height, toSize: height)
            
            staffMemberValueField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            staffMemberValueField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            staffMemberValueField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            staffMemberValueField.autoPinEdge(.right, to: .left, of: staffMemberArrowRightImgView, withOffset: -10)
            
            staffMemberArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            staffMemberArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            staffMemberArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            staffMemberValueAbstractView.autoPinEdgesToSuperviewEdges()
            
            //------------------------------------------------------------------------
            
            acceptanceDateView.autoPinEdge(.top, to: .bottom, of: staffMemberValueField)
            acceptanceDateView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            acceptanceDateView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            acceptanceDateView.autoSetDimension(.height, toSize: height)
            
            acceptanceDateLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            acceptanceDateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            acceptanceDateLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            acceptanceDateLabel.autoSetDimension(.height, toSize: 20)
            
            acceptanceDateValueView.autoPinEdge(.top, to: .bottom, of: acceptanceDateView)
            acceptanceDateValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            acceptanceDateValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            acceptanceDateValueView.autoSetDimension(.height, toSize: height)
            
            acceptanceDateValueField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            acceptanceDateValueField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            acceptanceDateValueField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            acceptanceDateValueField.autoPinEdge(.right, to: .left, of: acceptanceDateArrowRightImgView, withOffset: -10)
            
            acceptanceDateArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            acceptanceDateArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            acceptanceDateArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            acceptanceDateArrowRightAbstractView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 400
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func staffMember() {
        let viewController = AssignToViewController()
        viewController.assignToDelegate = self
        viewController.assign = assign
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func assignStaff(staff: User) {
        self.staff = staff
        self.assign.staffId = staff.id
        self.staffMemberValueField.text = staff.name
    }
    
    var fromDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "MM-dd-yyyy"
            
            if fromDate != nil {
                self.acceptanceDateValueField.text = dateFormatter.string(from: fromDate! as Date)
            }
            else {
                
            }
        }
    }
    
    func acceptanceDate() {
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
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    var isSaving = false
    
    func saveAssign() {
        if isSaving {
            return
        }
        
        if staffMemberValueField.text == "" {
            Utils.showAlert(title: "Error", message: "Staff member can not be empty!", viewController: self)
            return
        }
        
        if acceptanceDateValueField.text == "" {
            Utils.showAlert(title: "Error", message: "Accept by date can not be empty!", viewController: self)
            return
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let result = dateFormatter.string(from: date)
        
        let currentDate = dateFormatter.date(from: result)

        let previousDate = dateFormatter.date(from: acceptanceDateValueField.text!)
       
        if (currentDate?.isGreaterThanDate(dateToCompare: previousDate!))! {
            Utils.showAlert(title: "Error", message: "Accept by date should be greater than current date", viewController: self)
            return
        }
    
        isSaving = true
        
        assign = Assign()
        assign.staffId = staff.id
        assign.acceptanceDate = self.acceptanceDateValueField.text
        
        if assignJobDelegate != nil {
            assignJobDelegate.saveAssignJob(assign: assign)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
