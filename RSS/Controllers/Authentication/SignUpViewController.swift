//
//  SignUpViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/5/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import FontAwesomeKit
import SwiftOverlays
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate, LocationDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let iconImgView = UIImageView()
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
    
    let createAccountButton = UIButton()
    
    let alreadyView = UIView()
    let alreadyAccountButton = UIButton()
    let signInButton = UIButton()
    
    var constraintsAdded = false
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.tintColor = Global.colorSignin
        self.view.addTapToDismiss()
        
        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.image = UIImage(named: "Group")
        
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
        
        nameField.textAlignment = .center
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
        
        mailField.textAlignment = .center
        mailField.placeholder = "Email"
        mailField.delegate = self
        mailField.textColor = UIColor.black
        mailField.returnKeyType = .next
        mailField.keyboardType = .emailAddress
        mailField.inputAccessoryView = UIView()
        mailField.autocorrectionType = .no
        mailField.autocapitalizationType = .none
        mailField.font = UIFont(name: "OpenSans", size: 17)
        mailBorder.backgroundColor = Global.colorSeparator
        mailAbstract.backgroundColor = UIColor.white
        mailView.bringSubview(toFront: mailAbstract)
        
        businessNameField.textAlignment = .center
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
        phoneField.textAlignment = .center
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
        
        passwordField.textAlignment = .center
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
        
        locationField.textAlignment = .center
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
        arrowRightAbstract.backgroundColor = UIColor.white
        locationView.bringSubview(toFront: locationAbstract)
        locationView.bringSubview(toFront: arrowRightAbstract)
        locationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (location)))
        
        createAccountButton.setTitle("CREATE ACCOUNT", for: .normal)
        createAccountButton.backgroundColor = Global.colorSignin
        createAccountButton.setTitleColor(UIColor.white, for: .normal)
        createAccountButton.setTitleColor(Global.colorSelected, for: .highlighted)
        createAccountButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        createAccountButton.clipsToBounds = true
        
        alreadyAccountButton.setTitle("Already have an account?", for: .normal)
        alreadyAccountButton.setTitleColor(Global.colorGray, for: .normal)
        alreadyAccountButton.setTitleColor(Global.colorSignin, for: .highlighted)
        alreadyAccountButton.isUserInteractionEnabled = false
        alreadyAccountButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        alreadyAccountButton.sizeToFit()
        alreadyAccountButton.contentHorizontalAlignment = .center
        
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(Global.colorSignin, for: .normal)
        signInButton.setTitleColor(Global.colorSelected, for: .highlighted)
        signInButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInButton.sizeToFit()
        signInButton.contentHorizontalAlignment = .center
        
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
        locationView.addSubview(locationBorder)
        locationView.addSubview(locationAbstract)
        locationView.addSubview(arrowRightAbstract)
        
        alreadyView.addSubview(alreadyAccountButton)
        alreadyView.addSubview(signInButton)
        
        containerView.addSubview(iconImgView)
        containerView.addSubview(errorLabel)
        containerView.addSubview(nameView)
        containerView.addSubview(mailView)
        containerView.addSubview(businessNameView)
        containerView.addSubview(phoneView)
        containerView.addSubview(passwordView)
        containerView.addSubview(locationView)
        containerView.addSubview(createAccountButton)
        containerView.addSubview(alreadyView)
        
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
            
            let alpha: CGFloat = 40
            
            iconImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 50)
            iconImgView.autoSetDimensions(to: CGSize(width: 200, height: 35))
            iconImgView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            //---------------------------------------------------------------------------
            
            errorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            errorLabel.autoPinEdge(.top, to: .bottom, of: iconImgView, withOffset: 15)
            errorLabel.autoSetDimension(.height, toSize: 20)
            
            //---------------------------------------------------------------------------
            
            nameView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            nameView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            nameView.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 15)
            nameView.autoSetDimension(.height, toSize: 40)
            
            nameField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
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
            
            mailField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
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
            
            businessNameField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
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
            
            phoneField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
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
            
            passwordView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            passwordView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            passwordView.autoPinEdge(.top, to: .bottom, of: phoneView, withOffset: 10)
            passwordView.autoSetDimension(.height, toSize: 40)
            
            passwordField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            passwordField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            passwordField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            passwordField.autoSetDimension(.height, toSize: 40)
            
            passwordAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            passwordAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            passwordAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            passwordAbstract.autoSetDimension(.width, toSize: 25)
            
            keyImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            keyImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            keyImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            passwordBorder.autoPinEdge(toSuperviewEdge: .left)
            passwordBorder.autoPinEdge(toSuperviewEdge: .right)
            passwordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            passwordBorder.autoSetDimension(.height, toSize: 0.7)
            
            //---------------------------------------------------------------------------
            
            locationView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            locationView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            locationView.autoPinEdge(.top, to: .bottom, of: passwordView, withOffset: 10)
            locationView.autoSetDimension(.height, toSize: 40)
            
            locationField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
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
            
            locationBorder.autoPinEdge(toSuperviewEdge: .left)
            locationBorder.autoPinEdge(toSuperviewEdge: .right)
            locationBorder.autoPinEdge(toSuperviewEdge: .bottom)
            locationBorder.autoSetDimension(.height, toSize: 0.7)
            
            arrowRightAbstract.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            arrowRightAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            arrowRightAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            arrowRightAbstract.autoSetDimension(.width, toSize: 25)
            
            arrowRightImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            arrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 1)
            arrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            //---------------------------------------------------------------------------
            
            createAccountButton.autoPinEdge(toSuperviewEdge: .left, withInset: alpha - 2)
            createAccountButton.autoPinEdge(toSuperviewEdge: .right, withInset: alpha - 2)
            createAccountButton.autoPinEdge(.top, to: .bottom, of: locationView, withOffset: 30)
            createAccountButton.autoSetDimension(.height, toSize: 40)
            
            //---------------------------------------------------------------------------
            
            alreadyAccountButton.autoPinEdge(toSuperviewEdge: .top)
            alreadyAccountButton.autoPinEdge(toSuperviewEdge: .left)
            alreadyAccountButton.autoSetDimension(.height, toSize: 30)
            
            signInButton.autoPinEdge(toSuperviewEdge: .top)
            signInButton.autoPinEdge(toSuperviewEdge: .right)
            signInButton.autoPinEdge(.left, to: .right, of: alreadyAccountButton, withOffset: 5)
            signInButton.autoSetDimension(.height, toSize: 30)
            
            alreadyView.autoAlignAxis(toSuperviewAxis: .vertical)
            alreadyView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            alreadyView.autoSetDimension(.height, toSize: 30)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = Global.SCREEN_HEIGHT
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func signUp() {
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
        if !checkInput(textField: passwordField, value: passwordField.text) {
            return
        }
        if !checkInput(textField: locationField, value: locationField.text) {
            return
        }
        
        view.endEditing(true)
        
        SwiftOverlays.showBlockingWaitOverlay()
        FIRAuth.auth()!.createUser(withEmail: self.mailField.text!, password: self.passwordField.text!) { user, error in
            if error == nil {
                let location = Location()
                location.location = ""
                location.fullAddress = self.locationField.text
                
                self.user.id = (user?.uid)!
                self.user.email = self.mailField.text
                self.user.name = self.nameField.text
                self.user.businessName = self.businessNameField.text
                self.user.phone = self.phoneField.text
                self.user.location = location
                self.user.type = 1
                
                DatabaseHelper.shared.saveUser(user: self.user) {
                    FIRAuth.auth()!.signIn(withEmail: self.mailField.text!, password: self.passwordField.text!, completion: { (user: FIRUser?, error) in
                        SwiftOverlays.removeAllBlockingOverlays()
                        if error == nil {
                            FIRMessaging.messaging().subscribe(toTopic: "/topics/" + (user?.uid)!)
                            UserDefaultManager.getInstance().setUserType(value: true)
                            UserDefaultManager.getInstance().setCurrentPasswordUser(value: self.passwordField.text!)
                            let viewController = MainViewController()
                            self.present(viewController, animated: true, completion: nil)
                        }
                        else {
                            Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
                        }
                    })
                }
            }
            else {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "Email is already exist. Please try again!", viewController: self)
            }
        }
    }
    
    func signIn() {
        dismiss(animated: true, completion: nil)
    }
    
    func location() {
        let viewController = LocationViewController()
        viewController.locationDelegate = self
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated: true, completion: nil)
    }
    
    func saveLocation(location: Location) {
        locationField.text = location.fullAddress
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
                passwordField.becomeFirstResponder()
                return true
            }
        case passwordField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                return true
            }
        default:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                signIn()
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
            
        case passwordField:
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                passwordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid password"
            passwordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                locationBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid location"
            locationBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        }
        return false
    }
}
