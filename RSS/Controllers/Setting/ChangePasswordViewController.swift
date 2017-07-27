//
//  ChangePasswordViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/3/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import Firebase
import SwiftOverlays

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    let scrollView = UIScrollView()
    let containerView = UIView()
    let borderView = UIView()
    
    let errorLabel = UILabel()
    
    let previousPasswordView = UIView()
    let previousPasswordField = UITextField()
    let previousPasswordBorder = UIView()
    let previousPassowrdImgView = UIImageView()
    let previousPasswordAbstract = UIView()

    let newPasswordView = UIView()
    let newPasswordField = UITextField()
    let newPasswordBorder = UIView()
    let newPassowrdImgView = UIImageView()
    let newPasswordAbstract = UIView()

    let confirmPasswordView = UIView()
    let confirmPasswordField = UITextField()
    let confirmPasswordBorder = UIView()
    let confirmPassowrdImgView = UIImageView()
    let confirmPasswordAbstract = UIView()

    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Global.colorBg
        self.view.tintColor = Global.colorSignin
        self.view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = "CHANGE PASSWORD"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
        saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin,NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        containerView.backgroundColor = UIColor.white
        borderView.backgroundColor = Global.colorSeparator
        
        previousPassowrdImgView.clipsToBounds = true
        previousPassowrdImgView.contentMode = .scaleAspectFit
        previousPassowrdImgView.image = UIImage(named: "Key")
        
        newPassowrdImgView.clipsToBounds = true
        newPassowrdImgView.contentMode = .scaleAspectFit
        newPassowrdImgView.image = UIImage(named: "Key")
        
        confirmPassowrdImgView.clipsToBounds = true
        confirmPassowrdImgView.contentMode = .scaleAspectFit
        confirmPassowrdImgView.image = UIImage(named: "Key")
        
        errorLabel.font = UIFont(name: "OpenSans", size: 14)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        previousPasswordField.textAlignment = .center
        previousPasswordField.placeholder = "Previous Password"
        previousPasswordField.delegate = self
        previousPasswordField.textColor = UIColor.black
        previousPasswordField.returnKeyType = .next
        previousPasswordField.keyboardType = .namePhonePad
        previousPasswordField.isSecureTextEntry = true
        previousPasswordField.inputAccessoryView = UIView()
        previousPasswordField.autocorrectionType = .no
        previousPasswordField.autocapitalizationType = .none
        previousPasswordField.font = UIFont(name: "OpenSans", size: 17)
        previousPasswordBorder.backgroundColor = Global.colorSeparator
        previousPasswordAbstract.backgroundColor = UIColor.white
        previousPasswordView.bringSubview(toFront: previousPasswordAbstract)
        
        newPasswordField.textAlignment = .center
        newPasswordField.placeholder = "New Password"
        newPasswordField.delegate = self
        newPasswordField.textColor = UIColor.black
        newPasswordField.returnKeyType = .next
        newPasswordField.keyboardType = .namePhonePad
        newPasswordField.isSecureTextEntry = true
        newPasswordField.inputAccessoryView = UIView()
        newPasswordField.autocorrectionType = .no
        newPasswordField.autocapitalizationType = .none
        newPasswordField.font = UIFont(name: "OpenSans", size: 17)
        newPasswordBorder.backgroundColor = Global.colorSeparator
        newPasswordAbstract.backgroundColor = UIColor.white
        newPasswordView.bringSubview(toFront: newPasswordAbstract)
        
        confirmPasswordField.textAlignment = .center
        confirmPasswordField.placeholder = "Confirm Password"
        confirmPasswordField.delegate = self
        confirmPasswordField.textColor = UIColor.black
        confirmPasswordField.returnKeyType = .done
        confirmPasswordField.keyboardType = .namePhonePad
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.inputAccessoryView = UIView()
        confirmPasswordField.autocorrectionType = .no
        confirmPasswordField.autocapitalizationType = .none
        confirmPasswordField.font = UIFont(name: "OpenSans", size: 17)
        confirmPasswordBorder.backgroundColor = Global.colorSeparator
        confirmPasswordAbstract.backgroundColor = UIColor.white
        confirmPasswordView.bringSubview(toFront: confirmPasswordAbstract)
        
        previousPasswordView.addSubview(previousPasswordField)
        previousPasswordView.addSubview(previousPasswordBorder)
        previousPasswordView.addSubview(previousPasswordAbstract)
        previousPasswordView.addSubview(previousPassowrdImgView)

        newPasswordView.addSubview(newPasswordField)
        newPasswordView.addSubview(newPasswordBorder)
        newPasswordView.addSubview(newPasswordAbstract)
        newPasswordView.addSubview(newPassowrdImgView)

        confirmPasswordView.addSubview(confirmPasswordField)
        confirmPasswordView.addSubview(confirmPasswordBorder)
        confirmPasswordView.addSubview(confirmPasswordAbstract)
        confirmPasswordView.addSubview(confirmPassowrdImgView)

        containerView.addSubview(borderView)
        containerView.addSubview(errorLabel)
        containerView.addSubview(previousPasswordView)
        containerView.addSubview(newPasswordView)
        containerView.addSubview(confirmPasswordView)
  
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
            
            previousPasswordView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            previousPasswordView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            previousPasswordView.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 5)
            previousPasswordView.autoSetDimension(.height, toSize: 40)
            
            previousPasswordField.autoPinEdge(.left, to: .right, of: previousPasswordAbstract, withOffset: 5)
            previousPasswordField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            previousPasswordField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            previousPasswordField.autoSetDimension(.height, toSize: 40)
            
            previousPasswordAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            previousPasswordAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            previousPasswordAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            previousPasswordAbstract.autoSetDimension(.width, toSize: 25)
            
            previousPassowrdImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            previousPassowrdImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            previousPassowrdImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
         
            previousPasswordBorder.autoPinEdge(toSuperviewEdge: .left)
            previousPasswordBorder.autoPinEdge(toSuperviewEdge: .right)
            previousPasswordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            previousPasswordBorder.autoSetDimension(.height, toSize: 0.7)
            
            //---------------------------------------------------------------------------
            
            newPasswordView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            newPasswordView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            newPasswordView.autoPinEdge(.top, to: .bottom, of: previousPasswordView, withOffset: 10)
            newPasswordView.autoSetDimension(.height, toSize: 40)
            
            newPasswordField.autoPinEdge(.left, to: .right, of: newPasswordAbstract, withOffset: 5)
            newPasswordField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            newPasswordField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            newPasswordField.autoSetDimension(.height, toSize: 40)
            
            newPasswordAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            newPasswordAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            newPasswordAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            newPasswordAbstract.autoSetDimension(.width, toSize: 25)
            
            newPassowrdImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            newPassowrdImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            newPassowrdImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            
            newPasswordBorder.autoPinEdge(toSuperviewEdge: .left)
            newPasswordBorder.autoPinEdge(toSuperviewEdge: .right)
            newPasswordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            newPasswordBorder.autoSetDimension(.height, toSize: 0.7)
            
            //---------------------------------------------------------------------------
            
            confirmPasswordView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            confirmPasswordView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            confirmPasswordView.autoPinEdge(.top, to: .bottom, of: newPasswordView, withOffset: 10)
            confirmPasswordView.autoSetDimension(.height, toSize: 40)
            
            confirmPasswordField.autoPinEdge(.left, to: .right, of: confirmPasswordAbstract, withOffset: 5)
            confirmPasswordField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            confirmPasswordField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            confirmPasswordField.autoSetDimension(.height, toSize: 40)
            
            confirmPasswordAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            confirmPasswordAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            confirmPasswordAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            confirmPasswordAbstract.autoSetDimension(.width, toSize: 25)
            
            confirmPassowrdImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            confirmPassowrdImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            confirmPassowrdImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 175
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func save() {
        
        if !checkInput(textField: previousPasswordField, value: previousPasswordField.text) {
            return
        }
        if !checkInput(textField: newPasswordField, value: newPasswordField.text) {
            return
        }
        if !checkInput(textField: confirmPasswordField, value: confirmPasswordField.text) {
            return
        }
        
        view.endEditing(true)

        SwiftOverlays.showBlockingWaitOverlay()
        
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: (FIRAuth.auth()?.currentUser?.email)!, password: previousPasswordField.text!)
        
        user?.reauthenticate(with: credential, completion: { (error) in
            if error != nil {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "RSS", message: "Current password is incorrect. Please try again!", viewController: self)
            }
            else {
                user?.updatePassword(self.newPasswordField.text!) { error in
                    SwiftOverlays.removeAllBlockingOverlays()
                    if error != nil {
                        Utils.showAlert(title: "RSS", message: "Change password error!", viewController: self)
                    }
                    else {
                        Utils.showAlert(title: "RSS", message: "Change password successfully!", viewController: self)
                    }
                }
            }
        })
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case previousPasswordField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                newPasswordField.becomeFirstResponder()
                return true
            }
        case newPasswordField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                confirmPasswordField.becomeFirstResponder()
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
        case previousPasswordField:
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                previousPasswordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid previous password"
            previousPasswordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case newPasswordField:
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                newPasswordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Invalid new password"
            newPasswordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && newPasswordField.text != nil && value! == newPasswordField.text! {
                errorLabel.text = nil
                confirmPasswordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "Password mismatch"
            confirmPasswordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
}
