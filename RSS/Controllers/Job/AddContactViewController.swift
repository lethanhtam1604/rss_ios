//
//  AddContactViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/24/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import FontAwesomeKit
import SwiftOverlays

protocol AddContactDelegate {
    func saveContact(contact: Contact, isCreate: Bool)
}

class AddContactViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let jobContactView = UIView()
    let jobContactLabel = UILabel()
    let jobContacValueView = UIView()
    let jobContactField = UITextField()
    let emailView = UIView()
    let emailLabel = UILabel()
    let emailValueView = UIView()
    let emailField = UITextField()
    let phoneView = UIView()
    let phoneLabel = UILabel()
    let phoneValueView = UIView()
    let phoneField = UITextField()
    let mobileView = UIView()
    let mobileLabel = UILabel()
    let mobileValueView = UIView()
    let mobileField = UITextField()
    
    var constraintsAdded = false
    
    var addContactDelegate: AddContactDelegate!
    var contact: Contact!
    var isCreate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = "CONTACT"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
        saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        jobContactView.backgroundColor = UIColor.clear
        jobContacValueView.backgroundColor = UIColor.white
        emailView.backgroundColor = UIColor.clear
        emailValueView.backgroundColor = UIColor.white
        phoneView.backgroundColor = UIColor.clear
        phoneValueView.backgroundColor = UIColor.white
        mobileView.backgroundColor = UIColor.clear
        mobileValueView.backgroundColor = UIColor.white
        
        jobContactLabel.text = "JOB CONTACT"
        jobContactLabel.font = UIFont(name: "OpenSans", size: 15)
        jobContactLabel.textAlignment = .left
        jobContactLabel.textColor = Global.colorGray
        jobContactLabel.numberOfLines = 1
        
        jobContactField.delegate = self
        jobContactField.textAlignment = .left
        jobContactField.placeholder = "Name"
        jobContactField.textColor = UIColor.black
        jobContactField.returnKeyType = .next
        jobContactField.keyboardType = .namePhonePad
        jobContactField.inputAccessoryView = UIView()
        jobContactField.autocorrectionType = .no
        jobContactField.autocapitalizationType = .none
        jobContactField.font = UIFont(name: "OpenSans-semibold", size: 17)
        jobContactField.backgroundColor = UIColor.white
        
        emailLabel.text = "EMAIL"
        emailLabel.font = UIFont(name: "OpenSans", size: 15)
        emailLabel.textAlignment = .left
        emailLabel.textColor = Global.colorGray
        emailLabel.numberOfLines = 1
        
        emailField.delegate = self
        emailField.textAlignment = .left
        emailField.placeholder = "example@gmail.com"
        emailField.textColor = UIColor.black
        emailField.returnKeyType = .next
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.font = UIFont(name: "OpenSans-semibold", size: 17)
        emailField.backgroundColor = UIColor.white
        
        phoneLabel.text = "PHONE"
        phoneLabel.font = UIFont(name: "OpenSans", size: 15)
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = Global.colorGray
        phoneLabel.numberOfLines = 1
        
        phoneField.delegate = self
        phoneField.textAlignment = .left
        phoneField.placeholder = "0-000-000-0000"
        phoneField.textColor = UIColor.black
        phoneField.returnKeyType = .done
        phoneField.keyboardType = .phonePad
        phoneField.inputAccessoryView = UIView()
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneField.font = UIFont(name: "OpenSans-semibold", size: 17)
        phoneField.backgroundColor = UIColor.white
        
        
        mobileLabel.text = "MOBILE"
        mobileLabel.font = UIFont(name: "OpenSans", size: 15)
        mobileLabel.textAlignment = .left
        mobileLabel.textColor = Global.colorGray
        mobileLabel.numberOfLines = 1
        
        mobileField.delegate = self
        mobileField.textAlignment = .left
        mobileField.placeholder = "0-000-000-0000"
        mobileField.textColor = UIColor.black
        mobileField.returnKeyType = .done
        mobileField.keyboardType = .phonePad
        mobileField.inputAccessoryView = UIView()
        mobileField.autocorrectionType = .no
        mobileField.autocapitalizationType = .none
        mobileField.font = UIFont(name: "OpenSans-semibold", size: 17)
        mobileField.backgroundColor = UIColor.white
        
        jobContactView.addSubview(jobContactLabel)
        jobContacValueView.addSubview(jobContactField)
        emailView.addSubview(emailLabel)
        emailValueView.addSubview(emailField)
        phoneView.addSubview(phoneLabel)
        phoneValueView.addSubview(phoneField)
        mobileView.addSubview(mobileLabel)
        mobileValueView.addSubview(mobileField)
        
        containerView.addSubview(jobContactView)
        containerView.addSubview(jobContacValueView)
        containerView.addSubview(emailView)
        containerView.addSubview(emailValueView)
        containerView.addSubview(phoneView)
        containerView.addSubview(phoneValueView)
        containerView.addSubview(mobileView)
        containerView.addSubview(mobileValueView)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    func loadData() {
        if contact != nil {
            jobContactField.text = contact.jobContact
            emailField.text = contact.email
            phoneField.text = contact.phone
            mobileField.text = contact.mobile
        }
        else {
            contact = Contact()
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
            
            jobContactView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            jobContactView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            jobContactView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            jobContactView.autoSetDimension(.height, toSize: height)
            
            jobContactLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            jobContactLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            jobContactLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            jobContactLabel.autoSetDimension(.height, toSize: 20)
            
            jobContacValueView.autoPinEdge(.top, to: .bottom, of: jobContactView)
            jobContacValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            jobContacValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            jobContacValueView.autoSetDimension(.height, toSize: height)
            
            jobContactField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            jobContactField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            jobContactField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            jobContactField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            emailView.autoPinEdge(.top, to: .bottom, of: jobContacValueView)
            emailView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            emailView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            emailView.autoSetDimension(.height, toSize: height)
            
            emailLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            emailLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            emailLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            emailLabel.autoSetDimension(.height, toSize: 20)
            
            emailValueView.autoPinEdge(.top, to: .bottom, of: emailView)
            emailValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            emailValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            emailValueView.autoSetDimension(.height, toSize: height)
            
            emailField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            emailField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            emailField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            emailField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            phoneView.autoPinEdge(.top, to: .bottom, of: emailValueView)
            phoneView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            phoneView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            phoneView.autoSetDimension(.height, toSize: height)
            
            phoneLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            phoneLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            phoneLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            phoneLabel.autoSetDimension(.height, toSize: 20)
            
            phoneValueView.autoPinEdge(.top, to: .bottom, of: phoneView)
            phoneValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            phoneValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            phoneValueView.autoSetDimension(.height, toSize: height)
            
            phoneField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            phoneField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            phoneField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            phoneField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            mobileView.autoPinEdge(.top, to: .bottom, of: phoneValueView)
            mobileView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            mobileView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            mobileView.autoSetDimension(.height, toSize: height)
            
            mobileLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            mobileLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            mobileLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            mobileLabel.autoSetDimension(.height, toSize: 20)
            
            mobileValueView.autoPinEdge(.top, to: .bottom, of: mobileView)
            mobileValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            mobileValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            mobileValueView.autoSetDimension(.height, toSize: height)
            
            mobileField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            mobileField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            mobileField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            mobileField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
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
    
    func save() {
        if !checkInput(textField: jobContactField, value: jobContactField.text) {
            Utils.showAlert(title: "Error", message: "Job contact can not be empty!", viewController: self)
            return
        }
    
        if emailField.text == "" {
            Utils.showAlert(title: "Error", message: "Email can not be empty!", viewController: self)
            return
        }
        
        if !checkInput(textField: emailField, value: emailField.text) {
            Utils.showAlert(title: "Error", message: "Email is invalid!", viewController: self)
            return
        }
        
        if phoneField.text == "" && mobileField.text == "" {
            Utils.showAlert(title: "Error", message: "Phone or Mobile number can not be empty!", viewController: self)
            return
        }
        
        if phoneField.text != "" && !checkInput(textField: phoneField, value: phoneField.text) {
            Utils.showAlert(title: "Error", message: "Phone number is invalid!", viewController: self)
            return
        }
        
        if mobileField.text != "" && !checkInput(textField: mobileField, value: mobileField.text) {
            Utils.showAlert(title: "Error", message: "Mobile number is invalid!", viewController: self)
            return
        }
        
        view.endEditing(true)
        
        contact.jobContact = jobContactField.text
        contact.email = emailField.text
        contact.phone = phoneField.text
        contact.mobile = mobileField.text
        
        if addContactDelegate != nil {
            addContactDelegate.saveContact(contact: contact, isCreate: isCreate)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case jobContactField:
            textField.resignFirstResponder()
            emailField.becomeFirstResponder()
            return true
            
        case emailField:
            textField.resignFirstResponder()
            phoneField.becomeFirstResponder()
            return true
            
        default:
            textField.resignFirstResponder()
            return true
            
        }
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case jobContactField:
            if value != nil && value!.isValidName() {
                return true
            }
            
        case emailField:
            if value != nil && value!.isValidEmail() {
                return true
            }
            
        case phoneField:
            if value != nil && value!.isValidPhone() {
                return true
            }
        default:
            if value != nil && value!.isValidPhone() {
                return true
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == phoneField || textField == mobileField) {
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
}
