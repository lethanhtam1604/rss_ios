//
//  SignInViewController.swift
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

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let iconImgView = UIImageView()
    let errorLabel = UILabel()
    
    let mailView = UIView()
    let mailField = UITextField()
    let mailAbstract = UIView()
    let mailImgView = UIImageView()
    let mailBorder = UIView()
    
    let passwordView = UIView()
    let passwordField = UITextField()
    let passwordAbstract = UIView()
    let keyImgView = UIImageView()
    let passwordBorder = UIView()
    
    let forgotButton = UIButton()
    let signInButton = UIButton()
    let orLabel = UILabel()
    let newUserButton = UIButton()
    
    var constraintsAdded = false
    
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.setBadgeIndicatorForStaff(badgeCount: 0)
        
        self.view.backgroundColor = UIColor.white
        self.view.tintColor = Global.colorSignin
        self.view.addTapToDismiss()
        
        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.image = UIImage(named: "Group")
        
        mailImgView.clipsToBounds = true
        mailImgView.contentMode = .scaleAspectFit
        mailImgView.image = UIImage(named: "Mail")
        
        keyImgView.clipsToBounds = true
        keyImgView.contentMode = .scaleAspectFit
        keyImgView.image = UIImage(named: "Key")
        
        errorLabel.font = UIFont(name: "OpenSans", size: 14)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
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
        
        passwordField.textAlignment = .center
        passwordField.placeholder = "Password"
        passwordField.delegate = self
        passwordField.textColor = UIColor.black
        passwordField.returnKeyType = .go
        passwordField.keyboardType = .default
        passwordField.isSecureTextEntry = true
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordField.font = UIFont(name: "OpenSans", size: 17)
        passwordBorder.backgroundColor = Global.colorSeparator
        passwordAbstract.backgroundColor = UIColor.white
        passwordView.bringSubview(toFront: passwordAbstract)
        
        signInButton.setTitle("SIGN IN", for: .normal)
        signInButton.backgroundColor = Global.colorSignin
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.setTitleColor(Global.colorSelected, for: .highlighted)
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInButton.layer.cornerRadius = 5
        signInButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        signInButton.clipsToBounds = true
        
        orLabel.text = "OR"
        orLabel.font = UIFont(name: "OpenSans", size: 15)
        orLabel.textAlignment = .center
        orLabel.textColor = Global.colorGray
        orLabel.adjustsFontSizeToFitWidth = true
        
        newUserButton.setTitle("CREATE A NEW ACCOUNT", for: .normal)
        newUserButton.setTitleColor(Global.colorSignin, for: .normal)
        newUserButton.setTitleColor(Global.colorSelected, for: .highlighted)
        newUserButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        newUserButton.layer.cornerRadius = 5
        newUserButton.clipsToBounds = true
        newUserButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        newUserButton.layer.borderColor = Global.colorSignin.cgColor
        newUserButton.layer.borderWidth = 0.8
        
        forgotButton.setTitle("Forgot Password?", for: .normal)
        forgotButton.setTitleColor(Global.colorGray, for: .normal)
        forgotButton.setTitleColor(Global.colorSignin, for: .highlighted)
        forgotButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        forgotButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        forgotButton.sizeToFit()
        forgotButton.contentHorizontalAlignment = .center
        
        mailAbstract.addSubview(mailImgView)
        mailView.addSubview(mailField)
        mailView.addSubview(mailBorder)
        mailView.addSubview(mailAbstract)
        
        passwordAbstract.addSubview(keyImgView)
        passwordView.addSubview(passwordField)
        passwordView.addSubview(passwordBorder)
        passwordView.addSubview(passwordAbstract)
        
        containerView.addSubview(iconImgView)
        containerView.addSubview(orLabel)
        containerView.addSubview(errorLabel)
        containerView.addSubview(mailView)
        containerView.addSubview(passwordView)
        containerView.addSubview(forgotButton)
        containerView.addSubview(signInButton)
        containerView.addSubview(newUserButton)
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
            
            iconImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 100)
            iconImgView.autoSetDimensions(to: CGSize(width: 200, height: 45))
            iconImgView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            //---------------------------------------------------------------------------
            
            errorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            errorLabel.autoPinEdge(.top, to: .bottom, of: iconImgView, withOffset: 30)
            errorLabel.autoSetDimension(.height, toSize: 20)
            
            //---------------------------------------------------------------------------
            
            mailView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            mailView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            mailView.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 20)
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
            
            passwordView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            passwordView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            passwordView.autoPinEdge(.top, to: .bottom, of: mailView, withOffset: 10)
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
            
            signInButton.autoPinEdge(toSuperviewEdge: .left, withInset: alpha - 2)
            signInButton.autoPinEdge(toSuperviewEdge: .right, withInset: alpha - 2)
            signInButton.autoPinEdge(.top, to: .bottom, of: passwordView, withOffset: 30)
            signInButton.autoSetDimension(.height, toSize: 40)
            
            //---------------------------------------------------------------------------
            
            orLabel.autoPinEdge(toSuperviewEdge: .left)
            orLabel.autoPinEdge(toSuperviewEdge: .right)
            orLabel.autoPinEdge(.top, to: .bottom, of: signInButton, withOffset: 10)
            orLabel.autoSetDimension(.height, toSize: 30)
            
            //---------------------------------------------------------------------------
            
            newUserButton.autoPinEdge(toSuperviewEdge: .left, withInset: alpha - 2)
            newUserButton.autoPinEdge(toSuperviewEdge: .right, withInset: alpha - 2)
            newUserButton.autoPinEdge(.top, to: .bottom, of: orLabel, withOffset: 10)
            newUserButton.autoSetDimension(.height, toSize: 40)
            
            //---------------------------------------------------------------------------
            
            forgotButton.autoAlignAxis(toSuperviewAxis: .vertical)
            forgotButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            forgotButton.autoSetDimension(.height, toSize: 30)
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
    
    func signIn() {
        if !checkInput(textField: mailField, value: mailField.text) {
            return
        }
        if !checkInput(textField: passwordField, value: passwordField.text) {
            return
        }
        
        view.endEditing(true)
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        FIRAuth.auth()!.signIn(withEmail: mailField.text!, password: passwordField.text!, completion: { (user: FIRUser?, error) in
            if error == nil {
                let uid = user?.uid
                
                DatabaseHelper.shared.getUser(id: uid!) {
                    user in
                    SwiftOverlays.removeAllBlockingOverlays()
                    if user != nil {
                        if user?.type == 1 {
                            UserDefaultManager.getInstance().setUserType(value: true)
                        }
                        else {
                            UserDefaultManager.getInstance().setUserType(value: false)
                        }
                        
                        FIRMessaging.messaging().subscribe(toTopic: "/topics/" + uid!)
                        UserDefaultManager.getInstance().setCurrentPasswordUser(value: self.passwordField.text!)
                        
                        let viewController = MainViewController()
                        self.present(viewController, animated: true, completion: nil)
                    }
                    else {
                        Utils.showAlert(title: "Error", message: "Email or password is incorrect. Please try again!", viewController: self)
                    }
                }
            }
            else {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "Email or password is incorrect. Please try again!", viewController: self)
            }
        })
    }
    
    func signUp() {
        self.present(SignUpViewController(), animated:true, completion:nil)
    }
    
    func forgotPassword() {
        self.present(RecoverPasswordViewController(), animated:true, completion:nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case mailField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
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
        case mailField:
            if value != nil && value!.isValidEmail() {
                errorLabel.text = nil
                mailBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid email"
            mailBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                passwordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid password"
            passwordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        }
        return false
    }
}
