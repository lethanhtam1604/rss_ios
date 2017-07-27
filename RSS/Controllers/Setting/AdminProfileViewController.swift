//
//  AdminProfileViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/1/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import FontAwesomeKit
import SwiftOverlays
import Firebase

class AdminProfileViewController: UIViewController, UITextFieldDelegate, LocationDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let borderView = UIView()
    
    let errorLabel = UILabel()
    
    let nameView = UIView()
    let nameAbstract = UIView()
    let nameField = UITextField()
    let userImgView = UIImageView()
    let nameBorder = UIView()
    
    let mailView = UIView()
    let mailAbstract = UIView()
    let mailField = UITextField()
    let mailImgView = UIImageView()
    let mailBorder = UIView()
    
    let businessNameView = UIView()
    let businessNameAbstract = UIView()
    let businessNameField = UITextField()
    let businessImgView = UIImageView()
    let businessNameBorder = UIView()
    
    let phoneView = UIView()
    let phoneAbstract = UIView()
    let phoneField = UITextField()
    let phoneImgView = UIImageView()
    let phoneBorder = UIView()
    
    let passwordView = UIView()
    let passwordAbstract = UIView()
    let passwordField = UITextField()
    let keyImgView = UIImageView()
    let passwordBorder = UIView()
    
    let locationView = UIView()
    let locationAbstract = UIView()
    let arrowRightAbstract = UIView()
    let locationField = UITextField()
    let locationImgView = UIImageView()
    let arrowRightImgView = UIImageView()
    let locationBorder = UIView()
    
    let changePasswordButton = UIButton()
    var user = User()
    
    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Global.colorBg
        self.view.tintColor = Global.colorSignin
        self.view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = "PROFILE"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
        saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin,NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        containerView.backgroundColor = UIColor.white
        borderView.backgroundColor = Global.colorSeparator
        
        userImgView.clipsToBounds = true
        userImgView.contentMode = .scaleAspectFit
        userImgView.image = UIImage(named: "User")
        
        mailImgView.clipsToBounds = true
        mailImgView.contentMode = .scaleAspectFit
        mailImgView.image = UIImage(named: "Mail")
        
        businessImgView.clipsToBounds = true
        businessImgView.contentMode = .scaleAspectFit
        businessImgView.image = UIImage(named: "Business")
        
        phoneImgView.clipsToBounds = true
        phoneImgView.contentMode = .scaleAspectFit
        phoneImgView.image = UIImage(named: "Phone")
        
        keyImgView.clipsToBounds = true
        keyImgView.contentMode = .scaleAspectFit
        keyImgView.image = UIImage(named: "Key")
        
        arrowRightImgView.clipsToBounds = true
        arrowRightImgView.contentMode = .scaleAspectFit
        arrowRightImgView.image = UIImage(named: "ArrowRight")
        
        locationImgView.clipsToBounds = true
        locationImgView.contentMode = .scaleAspectFit
        locationImgView.image = UIImage(named: "Location")
        
        errorLabel.font = UIFont(name: "OpenSans", size: 14)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        nameField.text = "Katherine Cooper"
        nameField.textAlignment = .left
        nameField.placeholder = "Name"
        nameField.delegate = self
        nameField.textColor = UIColor.black
        nameField.returnKeyType = .next
        nameField.keyboardType = .namePhonePad
        nameField.inputAccessoryView = UIView()
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .none
        nameField.font = UIFont(name: "OpenSans", size: 17)
        nameBorder.backgroundColor = Global.colorSeparator
        nameAbstract.backgroundColor = UIColor.white
        nameView.bringSubview(toFront: nameAbstract)
        
        mailField.isUserInteractionEnabled = false
        mailField.text = "After.Typing@gmail.com"
        mailField.textAlignment = .left
        mailField.placeholder = "Email"
        mailField.delegate = self
        mailField.textColor = Global.colorGray
        mailField.returnKeyType = .next
        mailField.keyboardType = .emailAddress
        mailField.inputAccessoryView = UIView()
        mailField.autocorrectionType = .no
        mailField.autocapitalizationType = .none
        mailField.font = UIFont(name: "OpenSans", size: 17)
        mailBorder.backgroundColor = Global.colorSeparator
        mailAbstract.backgroundColor = UIColor.white
        mailView.bringSubview(toFront: mailAbstract)
        
        businessNameField.textAlignment = .left
        businessNameField.placeholder = "Business Name"
        businessNameField.delegate = self
        businessNameField.textColor = UIColor.black
        businessNameField.returnKeyType = .next
        businessNameField.keyboardType = .namePhonePad
        businessNameField.inputAccessoryView = UIView()
        businessNameField.autocorrectionType = .no
        businessNameField.autocapitalizationType = .none
        businessNameField.font = UIFont(name: "OpenSans", size: 17)
        businessNameBorder.backgroundColor = Global.colorSeparator
        businessNameAbstract.backgroundColor = UIColor.white
        businessNameView.bringSubview(toFront: businessNameAbstract)
        
        phoneField.delegate = self
        phoneField.textAlignment = .left
        phoneField.placeholder = "Phone"
        phoneField.delegate = self
        phoneField.textColor = UIColor.black
        phoneField.returnKeyType = .next
        phoneField.keyboardType = .phonePad
        phoneField.inputAccessoryView = UIView()
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneField.font = UIFont(name: "OpenSans", size: 17)
        phoneBorder.backgroundColor = Global.colorSeparator
        phoneAbstract.backgroundColor = UIColor.white
        phoneView.bringSubview(toFront: phoneAbstract)
        
        passwordField.textAlignment = .left
        passwordField.placeholder = "Password"
        passwordField.delegate = self
        passwordField.textColor = UIColor.black
        passwordField.returnKeyType = .next
        passwordField.keyboardType = .namePhonePad
        passwordField.isSecureTextEntry = true
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordField.font = UIFont(name: "OpenSans", size: 17)
        passwordBorder.backgroundColor = Global.colorSeparator
        passwordAbstract.backgroundColor = UIColor.white
        passwordView.bringSubview(toFront: passwordAbstract)
        
        locationField.textAlignment = .left
        locationField.placeholder = "Location"
        locationField.delegate = self
        locationField.textColor = UIColor.black
        locationField.returnKeyType = .go
        locationField.keyboardType = .namePhonePad
        locationField.inputAccessoryView = UIView()
        locationField.autocorrectionType = .no
        locationField.autocapitalizationType = .none
        locationField.font = UIFont(name: "OpenSans", size: 17)
        locationField.isUserInteractionEnabled = false
        locationBorder.backgroundColor = Global.colorSeparator
        locationAbstract.backgroundColor = UIColor.white
        locationView.bringSubview(toFront: locationAbstract)
        
        locationAbstract.backgroundColor = UIColor.white
        arrowRightAbstract.backgroundColor = UIColor.white
        locationView.bringSubview(toFront: locationAbstract)
        locationView.bringSubview(toFront: arrowRightAbstract)
        locationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (location)))
        
        changePasswordButton.setTitle("CHANGE PASSWORD", for: .normal)
        changePasswordButton.backgroundColor = Global.colorSignin
        changePasswordButton.setTitleColor(UIColor.white, for: .normal)
        changePasswordButton.setTitleColor(Global.colorSelected, for: .highlighted)
        changePasswordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        changePasswordButton.layer.cornerRadius = 5
        changePasswordButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        changePasswordButton.clipsToBounds = true
        
        nameAbstract.addSubview(userImgView)
        nameView.addSubview(nameField)
        nameView.addSubview(nameBorder)
        nameView.addSubview(nameAbstract)
        
        mailAbstract.addSubview(mailImgView)
        mailView.addSubview(mailField)
        mailView.addSubview(mailBorder)
        mailView.addSubview(mailAbstract)
        
        businessNameAbstract.addSubview(businessImgView)
        businessNameView.addSubview(businessNameField)
        businessNameView.addSubview(businessNameBorder)
        businessNameView.addSubview(businessNameAbstract)
        
        phoneAbstract.addSubview(phoneImgView)
        phoneView.addSubview(phoneField)
        phoneView.addSubview(phoneBorder)
        phoneView.addSubview(phoneAbstract)
        
        passwordAbstract.addSubview(keyImgView)
        passwordView.addSubview(passwordField)
        passwordView.addSubview(passwordBorder)
        passwordView.addSubview(passwordAbstract)
        
        locationAbstract.addSubview(locationImgView)
        arrowRightAbstract.addSubview(arrowRightImgView)
        locationView.addSubview(locationField)
        locationView.addSubview(locationAbstract)
        locationView.addSubview(arrowRightAbstract)
        locationView.addSubview(locationBorder)
        
        containerView.addSubview(borderView)
        containerView.addSubview(errorLabel)
        containerView.addSubview(nameView)
        containerView.addSubview(mailView)
        containerView.addSubview(businessNameView)
        containerView.addSubview(phoneView)
        containerView.addSubview(passwordView)
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
                self.user = user!
                self.updateUser()
            }
            
            // observe
            DatabaseHelper.shared.observeUsers() {
                newUser in
                if newUser.id == self.user.id {
                    self.user = newUser
                    self.updateUser()
                }
            }
        }
    }
    
    func updateUser() {
        self.nameField.text = user.name
        self.mailField.text = user.email
        self.businessNameField.text = user.businessName
        self.phoneField.text = user.phone
        self.locationField.text = user.location.fullAddress
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: view)
            
            let alpha: CGFloat = 40
            
            borderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            borderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            borderView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            borderView.autoSetDimension(.height, toSize: 0.5)
            
            //---------------------------------------------------------------------------
            
            errorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            errorLabel.autoSetDimension(.height, toSize: 20)
            
            //---------------------------------------------------------------------------
            
            nameView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            nameView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            nameView.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 5)
            nameView.autoSetDimension(.height, toSize: 40)
            
            nameField.autoPinEdge(.left, to: .right, of: nameAbstract, withOffset: 5)
            nameField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            nameField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            nameField.autoSetDimension(.height, toSize: 40)
            
            nameAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            nameAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            nameAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            nameAbstract.autoSetDimension(.width, toSize: 25)
            
            userImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            userImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            userImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            nameBorder.autoPinEdge(toSuperviewEdge: .left)
            nameBorder.autoPinEdge(toSuperviewEdge: .right)
            nameBorder.autoPinEdge(toSuperviewEdge: .bottom)
            nameBorder.autoSetDimension(.height, toSize: 0.7)
            
            //---------------------------------------------------------------------------
            
            mailView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            mailView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            mailView.autoPinEdge(.top, to: .bottom, of: nameView, withOffset: 10)
            mailView.autoSetDimension(.height, toSize: 40)
            
            mailField.autoPinEdge(.left, to: .right, of: mailAbstract, withOffset: 5)
            mailField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            mailField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            mailField.autoSetDimension(.height, toSize: 40)
            
            mailAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            mailAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            mailAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            mailAbstract.autoSetDimension(.width, toSize: 25)
            
            mailImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            mailImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            mailImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            mailBorder.autoPinEdge(toSuperviewEdge: .left)
            mailBorder.autoPinEdge(toSuperviewEdge: .right)
            mailBorder.autoPinEdge(toSuperviewEdge: .bottom)
            mailBorder.autoSetDimension(.height, toSize: 0.7)
            
            //---------------------------------------------------------------------------
            
            businessNameView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            businessNameView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            businessNameView.autoPinEdge(.top, to: .bottom, of: mailView, withOffset: 10)
            businessNameView.autoSetDimension(.height, toSize: 40)
            
            businessNameField.autoPinEdge(.left, to: .right, of: businessNameAbstract, withOffset: 5)
            businessNameField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            businessNameField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            businessNameField.autoSetDimension(.height, toSize: 40)
            
            businessNameAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            businessNameAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            businessNameAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            businessNameAbstract.autoSetDimension(.width, toSize: 25)
            
            businessImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            businessImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            businessImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            businessNameBorder.autoPinEdge(toSuperviewEdge: .left)
            businessNameBorder.autoPinEdge(toSuperviewEdge: .right)
            businessNameBorder.autoPinEdge(toSuperviewEdge: .bottom)
            businessNameBorder.autoSetDimension(.height, toSize: 0.7)
            
            //---------------------------------------------------------------------------
            
            phoneView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            phoneView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            phoneView.autoPinEdge(.top, to: .bottom, of: businessNameView, withOffset: 10)
            phoneView.autoSetDimension(.height, toSize: 40)
            
            phoneField.autoPinEdge(.left, to: .right, of: phoneAbstract, withOffset: 5)
            phoneField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            phoneField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            phoneField.autoSetDimension(.height, toSize: 40)
            
            phoneAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            phoneAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            phoneAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            phoneAbstract.autoSetDimension(.width, toSize: 25)
            
            phoneImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            phoneImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            phoneImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            phoneBorder.autoPinEdge(toSuperviewEdge: .left)
            phoneBorder.autoPinEdge(toSuperviewEdge: .right)
            phoneBorder.autoPinEdge(toSuperviewEdge: .bottom)
            phoneBorder.autoSetDimension(.height, toSize: 0.7)
            
            //---------------------------------------------------------------------------
            
            locationView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            locationView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            locationView.autoPinEdge(.top, to: .bottom, of: phoneView, withOffset: 10)
            locationView.autoSetDimension(.height, toSize: 40)
            
            locationField.autoPinEdge(.left, to: .right, of: locationAbstract, withOffset: 5)
            locationField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            locationField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            locationField.autoSetDimension(.height, toSize: 40)
            
            locationAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            locationAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            locationAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            locationAbstract.autoSetDimension(.width, toSize: 25)
            
            locationImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            locationImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            locationImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            arrowRightAbstract.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            arrowRightAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            arrowRightAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            arrowRightAbstract.autoSetDimension(.width, toSize: 25)
            
            arrowRightImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            arrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 1)
            arrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            locationBorder.autoPinEdge(toSuperviewEdge: .left)
            locationBorder.autoPinEdge(toSuperviewEdge: .right)
            locationBorder.autoPinEdge(toSuperviewEdge: .bottom)
            locationBorder.autoSetDimension(.height, toSize: 0.7)
            
            //---------------------------------------------------------------------------
            
            changePasswordButton.autoPinEdge(toSuperviewEdge: .left, withInset: alpha - 2)
            changePasswordButton.autoPinEdge(toSuperviewEdge: .right, withInset: alpha - 2)
            changePasswordButton.autoPinEdge(.top, to: .bottom, of: locationView, withOffset: 30)
            changePasswordButton.autoSetDimension(.height, toSize: 40)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 370
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func save() {
        
        if !checkInput(textField: nameField, value: nameField.text) {
            return
        }
        if !checkInput(textField: mailField, value: mailField.text) {
            return
        }
        if !checkInput(textField: businessNameField, value: businessNameField.text) {
            return
        }
        if !checkInput(textField: phoneField, value: phoneField.text) {
            return
        }
        if !checkInput(textField: locationField, value: locationField.text) {
            return
        }
        
        view.endEditing(true)
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        user.name = nameField.text
        user.email = mailField.text
        user.businessName = businessNameField.text
        user.phone = phoneField.text
        
        DatabaseHelper.shared.saveUser(user: self.user) {
            SwiftOverlays.removeAllBlockingOverlays()
            Utils.showAlert(title: "RSS", message: "Update profile successfully!", viewController: self)
        }
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func location() {
        let viewController = LocationViewController()
        viewController.locationDelegate = self
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func changePassword() {
        let viewController = ChangePasswordViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func saveLocation(location: Location) {
        locationField.text = location.fullAddress
        user.location = location
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newStr = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newStr)
        
        if (textField == phoneField) {
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
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                mailField.becomeFirstResponder()
                return true
            }
        case mailField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                businessNameField.becomeFirstResponder()
                return true
            }
        case businessNameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                phoneField.becomeFirstResponder()
                return true
            }
        case phoneField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                locationField.becomeFirstResponder()
                return true
            }
        default:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                return true
            }
        }
        return false
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case nameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                nameBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid name"
            nameBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case mailField:
            if value != nil && value!.isValidEmail() {
                errorLabel.text = nil
                mailBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid email"
            mailBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case businessNameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                businessNameBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid business name"
            businessNameBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case phoneField:
            if value != nil && value!.isValidPhone() {
                errorLabel.text = nil
                phoneBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid phone"
            phoneBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                return true
            }
            errorLabel.text = "Invalid location"
        }
        return false
    }
}
