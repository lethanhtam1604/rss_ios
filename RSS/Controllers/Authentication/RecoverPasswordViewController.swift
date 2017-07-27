//
//  RecoverPasswordViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/22/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import FontAwesomeKit
import SwiftOverlays
import Firebase

class RecoverPasswordViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let iconImgView = UIImageView()
    let errorLabel = UILabel()
    let titleLabel = UILabel()
    
    let mailView = UIView()
    let mailField = UITextField()
    let mailAbstract = UIView()
    let mailImgView = UIImageView()
    let mailBorder = UIView()
    
    let recoverPasswordButton = UIButton()
    
    let backToSignInView = UIView()
    let backToButton = UIButton()
    let signInButton = UIButton()
    
    var constraintsAdded = false
    
    let usersRef = FIRDatabase.database().reference(withPath: "users")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.tintColor = Global.colorSignin
        self.view.addTapToDismiss()
        
        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.image = UIImage(named: "Group")
        
        mailImgView.clipsToBounds = true
        mailImgView.contentMode = .scaleAspectFit
        mailImgView.image = UIImage(named: "Mail")
        
        errorLabel.font = UIFont(name: "OpenSans", size: 14)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.text = "Enter your email id to reset your password"
        titleLabel.font = UIFont(name: "OpenSans", size: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        
        mailField.textAlignment = .center
        mailField.placeholder = "Email"
        mailField.delegate = self
        mailField.textColor = UIColor.black
        mailField.returnKeyType = .done
        mailField.keyboardType = .emailAddress
        mailField.inputAccessoryView = UIView()
        mailField.autocorrectionType = .no
        mailField.autocapitalizationType = .none
        mailField.font = UIFont(name: "OpenSans", size: 17)
        mailBorder.backgroundColor = Global.colorSeparator
        mailAbstract.backgroundColor = UIColor.white
        mailView.bringSubview(toFront: mailAbstract)
        
        recoverPasswordButton.setTitle("RECOVER PASSWORD", for: .normal)
        recoverPasswordButton.backgroundColor = Global.colorSignin
        recoverPasswordButton.setTitleColor(UIColor.white, for: .normal)
        recoverPasswordButton.setTitleColor(Global.colorSelected, for: .highlighted)
        recoverPasswordButton.addTarget(self, action: #selector(recoverPassword), for: .touchUpInside)
        recoverPasswordButton.layer.cornerRadius = 5
        recoverPasswordButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        recoverPasswordButton.clipsToBounds = true
        
        backToButton.setTitle("Go back to", for: .normal)
        backToButton.setTitleColor(Global.colorGray, for: .normal)
        backToButton.setTitleColor(Global.colorSignin, for: .highlighted)
        backToButton.isUserInteractionEnabled = false
        backToButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        backToButton.sizeToFit()
        backToButton.contentHorizontalAlignment = .center
        
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(Global.colorSignin, for: .normal)
        signInButton.setTitleColor(Global.colorSelected, for: .highlighted)
        signInButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInButton.sizeToFit()
        signInButton.contentHorizontalAlignment = .center

        
        mailAbstract.addSubview(mailImgView)
        mailView.addSubview(mailField)
        mailView.addSubview(mailBorder)
        mailView.addSubview(mailAbstract)
        
        backToSignInView.addSubview(backToButton)
        backToSignInView.addSubview(signInButton)
        
        containerView.addSubview(iconImgView)
        containerView.addSubview(errorLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(mailView)
        containerView.addSubview(recoverPasswordButton)
        containerView.addSubview(backToSignInView)
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
            errorLabel.autoPinEdge(.top, to: .bottom, of: iconImgView, withOffset: 20)
            errorLabel.autoSetDimension(.height, toSize: 20)
            
            //---------------------------------------------------------------------------
            
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 65)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 65)
            titleLabel.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 20)
            
            //---------------------------------------------------------------------------
            
            mailView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            mailView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            mailView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
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
            
            recoverPasswordButton.autoPinEdge(toSuperviewEdge: .left, withInset: alpha - 2)
            recoverPasswordButton.autoPinEdge(toSuperviewEdge: .right, withInset: alpha - 2)
            recoverPasswordButton.autoPinEdge(.top, to: .bottom, of: mailView, withOffset: 40)
            recoverPasswordButton.autoSetDimension(.height, toSize: 40)
            
            //---------------------------------------------------------------------------
            
            backToButton.autoPinEdge(toSuperviewEdge: .top)
            backToButton.autoPinEdge(toSuperviewEdge: .left)
            backToButton.autoSetDimension(.height, toSize: 30)
            
            signInButton.autoPinEdge(toSuperviewEdge: .top)
            signInButton.autoPinEdge(toSuperviewEdge: .right)
            signInButton.autoPinEdge(.left, to: .right, of: backToButton, withOffset: 5)
            signInButton.autoSetDimension(.height, toSize: 30)
            
            backToSignInView.autoAlignAxis(toSuperviewAxis: .vertical)
            backToSignInView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            backToSignInView.autoSetDimension(.height, toSize: 30)
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
    
    func recoverPassword() {
        if !checkInput(textField: mailField, value: mailField.text) {
            return
        }
        
        view.endEditing(true)
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        self.usersRef.queryOrdered(byChild: "email").observe(.value, with: { snapshot in
            var flag = false
            for item in snapshot.children {
                let user = User(item as! FIRDataSnapshot)
                if user.email == self.mailField.text {
                    flag = true
                    break
                }
            }
            if flag {
                FIRAuth.auth()?.sendPasswordReset(withEmail: self.mailField.text!) { error in
                    if error == nil {
                        Utils.showAlert(title: "Successfully", message: "Your new password has been sent to " + self.mailField.text! + ". Please check your email!", viewController: self)
                    }
                    else {
                        Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
                    }
                    SwiftOverlays.removeAllBlockingOverlays()
                }
            }
            else {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "This email have not yet registered. Please try again!", viewController: self)
            }
        })

        
    }
    
    func signIn() {
        dismiss(animated: true, completion: nil)
    }
    
    func forgotPassword() {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
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
        default:
            if value != nil && value!.isValidEmail() {
                errorLabel.text = nil
                mailBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid email"
            mailBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        }
        return false
    }
}
