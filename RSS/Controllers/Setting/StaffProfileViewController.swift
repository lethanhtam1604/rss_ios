//
//  StaffProfileViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/2/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import Firebase
import SwiftOverlays

protocol StaffProfileDelegate {
    func saveStaffProfile()
}

class StaffProfileViewController: UIViewController, UITextFieldDelegate, LocationDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let staffNameHeaderView = UIView()
    let staffNameHeaderLabel = UILabel()
    
    let staffFirstNameView = UIView()
    let staffFirstNameField = UITextField()
    
    let staffLastNameView = UIView()
    let staffLastNameField = UITextField()
    
    let mobileHeaderView = UIView()
    let mobileHeaderLabel = UILabel()
    
    let mobileView = UIView()
    let mobileField = UITextField()
    
    let emailHeaderView = UIView()
    let emailHeaderLabel = UILabel()
    
    let emailView = UIView()
    let emailField = UITextField()
    
    let contractorView = UIView()
    let contractorLabel = UILabel()
    let contractorSwitch = UISwitch()
    
    let businessView = UIView()
    let businessField = UITextField()
    
    let locationView = UIView()
    let locationField = UITextField()
    let locationArrowRightImgView = UIImageView()
    let locationAbstractView = UIView()
    
    let changePasswordButton = UIButton()
    
    var staff = User()
    
    var constraintsAdded = false
    
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
        
        title = "STAFF"
        
        let cancelBarButton = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(cancel))
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
        saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        staffNameHeaderView.backgroundColor = UIColor.clear
        staffFirstNameView.backgroundColor = UIColor.white
        staffLastNameView.backgroundColor = UIColor.white
        mobileHeaderView.backgroundColor = UIColor.clear
        mobileView.backgroundColor = UIColor.white
        emailHeaderView.backgroundColor = UIColor.clear
        emailView.backgroundColor = UIColor.white
        contractorView.backgroundColor = UIColor.clear
        businessView.backgroundColor = UIColor.white
        locationView.backgroundColor = UIColor.white
        
        locationAbstractView.backgroundColor = UIColor.clear
        locationAbstractView.touchHighlightingStyle = .lightBackground
        let locationAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(location))
        locationAbstractView.addGestureRecognizer(locationAbstractViewGesture)
        
        staffNameHeaderLabel.text = "JOB CONTACT"
        staffNameHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        staffNameHeaderLabel.textAlignment = .left
        staffNameHeaderLabel.textColor = Global.colorGray
        staffNameHeaderLabel.numberOfLines = 1
        
        staffFirstNameField.delegate = self
        staffFirstNameField.textAlignment = .left
        staffFirstNameField.placeholder = "First Name"
        staffFirstNameField.textColor = UIColor.black
        staffFirstNameField.returnKeyType = .done
        staffFirstNameField.keyboardType = .namePhonePad
        staffFirstNameField.inputAccessoryView = UIView()
        staffFirstNameField.autocorrectionType = .no
        staffFirstNameField.autocapitalizationType = .none
        staffFirstNameField.font = UIFont(name: "OpenSans-semibold", size: 17)
        staffFirstNameField.backgroundColor = UIColor.white
        
        staffLastNameField.delegate = self
        staffLastNameField.textAlignment = .left
        staffLastNameField.placeholder = "Last Name"
        staffLastNameField.textColor = UIColor.black
        staffLastNameField.returnKeyType = .done
        staffLastNameField.keyboardType = .namePhonePad
        staffLastNameField.inputAccessoryView = UIView()
        staffLastNameField.autocorrectionType = .no
        staffLastNameField.autocapitalizationType = .none
        staffLastNameField.font = UIFont(name: "OpenSans-semibold", size: 17)
        staffLastNameField.backgroundColor = UIColor.white
        
        mobileHeaderLabel.text = "MOBILE"
        mobileHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        mobileHeaderLabel.textAlignment = .left
        mobileHeaderLabel.textColor = Global.colorGray
        mobileHeaderLabel.numberOfLines = 1
        
        mobileField.delegate = self
        mobileField.textAlignment = .left
        mobileField.placeholder = "0-000-000-000"
        mobileField.textColor = UIColor.black
        mobileField.returnKeyType = .done
        mobileField.keyboardType = .phonePad
        mobileField.inputAccessoryView = UIView()
        mobileField.autocorrectionType = .no
        mobileField.autocapitalizationType = .none
        mobileField.font = UIFont(name: "OpenSans-semibold", size: 17)
        mobileField.backgroundColor = UIColor.white
        
        emailHeaderLabel.text = "EMAIL"
        emailHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        emailHeaderLabel.textAlignment = .left
        emailHeaderLabel.textColor = Global.colorGray
        emailHeaderLabel.numberOfLines = 1
        
        emailField.delegate = self
        emailField.textAlignment = .left
        emailField.placeholder = "example@gmail.com"
        emailField.textColor = Global.colorGray
        emailField.returnKeyType = .done
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.font = UIFont(name: "OpenSans-semibold", size: 17)
        emailField.backgroundColor = UIColor.white
        emailField.isUserInteractionEnabled = false
        
        contractorLabel.text = "CONTRACTOR"
        contractorLabel.font = UIFont(name: "OpenSans", size: 15)
        contractorLabel.textAlignment = .left
        contractorLabel.textColor = Global.colorGray
        contractorLabel.numberOfLines = 1
        
        contractorSwitch.onTintColor = Global.colorSwitchBg
        contractorSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        contractorSwitch.thumbTintColor = Global.colorSwitchBtn
        contractorSwitch.addTarget(self, action: #selector(contractorChanged), for: .valueChanged)
        
        if contractorSwitch.isOn {
            contractorSwitch.thumbTintColor = Global.colorSwitchBtn
            businessField.textColor = UIColor.black
            businessField.isUserInteractionEnabled = true
            locationField.textColor = UIColor.black
            locationAbstractView.isUserInteractionEnabled = true
        } else {
            contractorSwitch.thumbTintColor = Global.colorGray
            businessField.textColor = Global.colorGray
            businessField.isUserInteractionEnabled = false
            locationField.textColor = Global.colorGray
            locationAbstractView.isUserInteractionEnabled = false
        }
        
        businessField.delegate = self
        businessField.textAlignment = .left
        businessField.placeholder = "Business Name"
        businessField.textColor = UIColor.black
        businessField.returnKeyType = .done
        businessField.keyboardType = .namePhonePad
        businessField.inputAccessoryView = UIView()
        businessField.autocorrectionType = .no
        businessField.autocapitalizationType = .none
        businessField.font = UIFont(name: "OpenSans-semibold", size: 17)
        businessField.backgroundColor = UIColor.white
        
        locationField.delegate = self
        locationField.textAlignment = .left
        locationField.placeholder = "Location"
        locationField.textColor = UIColor.black
        locationField.returnKeyType = .done
        locationField.keyboardType = .emailAddress
        locationField.inputAccessoryView = UIView()
        locationField.autocorrectionType = .no
        locationField.autocapitalizationType = .none
        locationField.font = UIFont(name: "OpenSans-semibold", size: 17)
        locationField.backgroundColor = UIColor.white
        locationField.isUserInteractionEnabled = false
        
        locationArrowRightImgView.clipsToBounds = true
        locationArrowRightImgView.contentMode = .scaleAspectFit
        locationArrowRightImgView.image = UIImage(named: "ArrowRight")
        
        changePasswordButton.setTitle("CHANGE PASSWORD", for: .normal)
        changePasswordButton.backgroundColor = Global.colorSignin
        changePasswordButton.setTitleColor(UIColor.white, for: .normal)
        changePasswordButton.setTitleColor(Global.colorSelected, for: .highlighted)
        changePasswordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        changePasswordButton.layer.cornerRadius = 5
        changePasswordButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        changePasswordButton.clipsToBounds = true
        
        staffNameHeaderView.addSubview(staffNameHeaderLabel)
        staffFirstNameView.addSubview(staffFirstNameField)
        staffLastNameView.addSubview(staffLastNameField)
        mobileHeaderView.addSubview(mobileHeaderLabel)
        mobileView.addSubview(mobileField)
        emailHeaderView.addSubview(emailHeaderLabel)
        emailView.addSubview(emailField)
        contractorView.addSubview(contractorLabel)
        contractorView.addSubview(contractorSwitch)
        businessView.addSubview(businessField)
        locationView.addSubview(locationField)
        locationView.addSubview(locationArrowRightImgView)
        locationView.addSubview(locationAbstractView)
        
        containerView.addSubview(staffNameHeaderView)
        containerView.addSubview(staffFirstNameView)
        containerView.addSubview(staffLastNameView)
        containerView.addSubview(mobileHeaderView)
        containerView.addSubview(mobileView)
        containerView.addSubview(emailHeaderView)
        containerView.addSubview(emailView)
        containerView.addSubview(contractorView)
        containerView.addSubview(businessView)
        containerView.addSubview(locationView)
        containerView.addSubview(changePasswordButton)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        view.setNeedsUpdateConstraints()
        loadData()
    }
    
    func loadData() {
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            
            if user != nil {
                self.staff = user!
                self.updateUser()
            }
            
            // observe
            DatabaseHelper.shared.observeUsers() {
                newUser in
                if newUser.id == self.staff.id {
                    self.staff = newUser
                    self.updateUser()
                }
            }
        }
    }
    
    func updateUser() {
        staffFirstNameField.text = staff.name
        staffLastNameField.text = staff.lastName
        mobileField.text = staff.phone
        emailField.text = staff.email
        contractorSwitch.setOn(staff.contractor!, animated: false)
        businessField.text = staff.businessName
        locationField.text = staff.location.fullAddress
        
        if staff.contractor! {
            onContractor()
        }
        else {
            offContractor()
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
            
            staffNameHeaderView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            staffNameHeaderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            staffNameHeaderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            staffNameHeaderView.autoSetDimension(.height, toSize: height)
            
            staffNameHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            staffNameHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            staffNameHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            staffNameHeaderLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------
            
            staffFirstNameView.autoPinEdge(.top, to: .bottom, of: staffNameHeaderView)
            staffFirstNameView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            staffFirstNameView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            staffFirstNameView.autoSetDimension(.height, toSize: height)
            
            staffFirstNameField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            staffFirstNameField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            staffFirstNameField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            staffFirstNameField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            staffLastNameView.autoPinEdge(.top, to: .bottom, of: staffFirstNameView)
            staffLastNameView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            staffLastNameView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            staffLastNameView.autoSetDimension(.height, toSize: height)
            
            staffLastNameField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            staffLastNameField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            staffLastNameField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            staffLastNameField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            mobileHeaderView.autoPinEdge(.top, to: .bottom, of: staffLastNameView)
            mobileHeaderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            mobileHeaderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            mobileHeaderView.autoSetDimension(.height, toSize: height)
            
            mobileHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            mobileHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            mobileHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            mobileHeaderLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------
            
            mobileView.autoPinEdge(.top, to: .bottom, of: mobileHeaderView)
            mobileView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            mobileView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            mobileView.autoSetDimension(.height, toSize: height)
            
            mobileField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            mobileField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            mobileField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            mobileField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            emailHeaderView.autoPinEdge(.top, to: .bottom, of: mobileView)
            emailHeaderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            emailHeaderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            emailHeaderView.autoSetDimension(.height, toSize: height)
            
            emailHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            emailHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            emailHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            emailHeaderLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------
            
            emailView.autoPinEdge(.top, to: .bottom, of: emailHeaderView)
            emailView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            emailView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            emailView.autoSetDimension(.height, toSize: height)
            
            emailField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            emailField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            emailField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            emailField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            contractorView.autoPinEdge(.top, to: .bottom, of: emailView)
            contractorView.autoPinEdge(toSuperviewEdge: .right)
            contractorView.autoPinEdge(toSuperviewEdge: .left)
            contractorView.autoSetDimension(.height, toSize: height)
            
            contractorLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            contractorLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            contractorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            contractorLabel.autoPinEdge(.right, to: .left, of: contractorSwitch, withOffset: 10)
            
            contractorSwitch.autoSetDimensions(to: CGSize(width: 30, height: 30))
            contractorSwitch.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
            contractorSwitch.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            
            //------------------------------------------------------------------------
            
            businessView.autoPinEdge(.top, to: .bottom, of: contractorView)
            businessView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            businessView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            businessView.autoSetDimension(.height, toSize: height)
            
            businessField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            businessField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            businessField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            businessField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            locationView.autoPinEdge(.top, to: .bottom, of: businessView, withOffset: 2)
            locationView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            locationView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            locationView.autoSetDimension(.height, toSize: height)
            
            locationField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            locationField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            locationField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            locationField.autoPinEdge(.right, to: .left, of: locationArrowRightImgView, withOffset: 10)
            
            locationArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            locationArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            locationArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            locationAbstractView.autoPinEdgesToSuperviewEdges()
            
            //------------------------------------------------------------------------
            
            changePasswordButton.autoPinEdge(toSuperviewEdge: .left, withInset: 40 - 2)
            changePasswordButton.autoPinEdge(toSuperviewEdge: .right, withInset: 40 - 2)
            changePasswordButton.autoPinEdge(.top, to: .bottom, of: locationView, withOffset: 30)
            changePasswordButton.autoSetDimension(.height, toSize: 40)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 600
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func save() {
        if !checkInput(textField: staffFirstNameField, value: staffFirstNameField.text) {
            Utils.showAlert(title: "Error", message: "First Name can not be empty!", viewController: self)
            return
        }
        
        if !checkInput(textField: staffLastNameField, value: staffLastNameField.text) {
            Utils.showAlert(title: "Error", message: "Last Name can not be empty!", viewController: self)
            return
        }
        
        if mobileField.text == "" {
            Utils.showAlert(title: "Error", message: "Mobile number can not be empty!", viewController: self)
            return
        }
        
        if !checkInput(textField: mobileField, value: mobileField.text) {
            Utils.showAlert(title: "Error", message: "Mobile number is invalid!", viewController: self)
            return
        }
        
        if contractorSwitch.isOn {
            if !checkInput(textField: businessField, value: businessField.text) {
                Utils.showAlert(title: "Error", message: "Business Name can not be empty!", viewController: self)
                return
            }
            
            if !checkInput(textField: locationField, value: locationField.text) {
                Utils.showAlert(title: "Error", message: "Location can not be empty!", viewController: self)
                return
            }
        }
        
        view.endEditing(true)
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        self.staff.name = self.staffFirstNameField.text
        self.staff.lastName = self.staffLastNameField.text
        self.staff.phone = self.mobileField.text
        self.staff.email = self.emailField.text
        self.staff.businessName = self.businessField.text
        
        if self.contractorSwitch.isOn {
            self.staff.contractor = true
        }
        else {
            self.staff.contractor = false
        }
        
        DatabaseHelper.shared.saveUser(user: self.staff) {
            SwiftOverlays.removeAllBlockingOverlays()
            Utils.showAlert(title: "RSS", message: "Update profile successfully!", viewController: self)
        }
        
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func changePassword() {
        let viewController = ChangePasswordViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func location() {
        let viewController = LocationViewController()
        viewController.locationDelegate = self
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func saveLocation(location: Location) {
        locationField.text = location.fullAddress
        staff.location = location
    }
    
    func contractorChanged(_sender: UISwitch) {
        if _sender.isOn {
            onContractor()
        }
        else {
            offContractor()
        }
    }
    
    func onContractor() {
        contractorSwitch.thumbTintColor = Global.colorSwitchBtn
        businessField.textColor = UIColor.black
        businessField.isUserInteractionEnabled = true
        locationField.textColor = UIColor.black
        locationAbstractView.isUserInteractionEnabled = true
    }
    
    func offContractor() {
        contractorSwitch.thumbTintColor = Global.colorGray
        businessField.textColor = Global.colorGray
        businessField.isUserInteractionEnabled = false
        locationField.textColor = Global.colorGray
        locationAbstractView.isUserInteractionEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case staffFirstNameField:
            textField.resignFirstResponder()
            staffLastNameField.becomeFirstResponder()
            return true
        case staffLastNameField:
            textField.resignFirstResponder()
            mobileField.becomeFirstResponder()
            return true
        case mobileField:
            textField.resignFirstResponder()
            emailField.becomeFirstResponder()
            return true
        case emailField:
            textField.resignFirstResponder()
            if (contractorSwitch.isOn) {
                businessField.becomeFirstResponder()
                return true
            }
        default:
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if (textField == mobileField) {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if string == "" && newString == "1" {
                textField.text = ""
                return true
            }
            
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.hasPrefix("1")
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        else {
            return true
        }
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case staffFirstNameField:
            if value != nil && value!.isValidName() {
                return true
            }
            
        case staffLastNameField:
            if value != nil && value!.isValidName() {
                return true
            }
            
        case mobileField:
            if value != nil && value!.isValidPhone() {
                return true
            }
        case emailField:
            if value != nil && value!.isValidEmail() {
                return true
            }
        case businessField:
            if value != nil && value!.isValidName() {
                return true
            }
        default:
            if value != nil && value!.isValidAddress() {
                return true
            }
        }
        return false
    }
}
