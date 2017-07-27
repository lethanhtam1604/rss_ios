//
//  ContactViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/27/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
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
    let emailIconImgView = UIButton()
    let phoneView = UIView()
    let phoneLabel = UILabel()
    let phoneValueView = UIView()
    let phoneField = UITextField()
    let phoneIconImgView = UIButton()
    let mobileView = UIView()
    let mobileLabel = UILabel()
    let mobileValueView = UIView()
    let mobileField = UITextField()
    let mobileIconImgView = UIButton()
    
    var constraintsAdded = false
    
    var addContactDelegate: AddContactDelegate!
    
    var contact = Contact()
    
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
        
        jobContactField.textAlignment = .left
        jobContactField.text = "Danielle Rodriguez"
        jobContactField.textColor = UIColor.black
        jobContactField.returnKeyType = .done
        jobContactField.keyboardType = .namePhonePad
        jobContactField.inputAccessoryView = UIView()
        jobContactField.autocorrectionType = .no
        jobContactField.autocapitalizationType = .none
        jobContactField.font = UIFont(name: "OpenSans-semibold", size: 17)
        jobContactField.backgroundColor = UIColor.white
        jobContactField.isUserInteractionEnabled = false
        
        emailLabel.text = "EMAIL"
        emailLabel.font = UIFont(name: "OpenSans", size: 15)
        emailLabel.textAlignment = .left
        emailLabel.textColor = Global.colorGray
        emailLabel.numberOfLines = 1
        
        emailField.textAlignment = .left
        emailField.placeholder = "example@gmail.com"
        emailField.text = "lethanhtam1604@gmail.com"
        emailField.textColor = UIColor.black
        emailField.returnKeyType = .done
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.font = UIFont(name: "OpenSans-semibold", size: 17)
        emailField.backgroundColor = UIColor.white
        emailField.isUserInteractionEnabled = false
        
        emailIconImgView.setImage(UIImage(named: "i_list_email"), for: .normal)
        emailIconImgView.backgroundColor = UIColor.clear
        emailIconImgView.addTarget(self, action: #selector(email), for: .touchUpInside)
        emailIconImgView.clipsToBounds = true
        
        phoneLabel.text = "PHONE"
        phoneLabel.font = UIFont(name: "OpenSans", size: 15)
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = Global.colorGray
        phoneLabel.numberOfLines = 1
        
        phoneField.textAlignment = .left
        phoneField.placeholder = "0-000-000-0000"
        phoneField.text = "1-800-123-567"
        phoneField.textColor = UIColor.black
        phoneField.returnKeyType = .done
        phoneField.keyboardType = .phonePad
        phoneField.inputAccessoryView = UIView()
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneField.font = UIFont(name: "OpenSans-semibold", size: 17)
        phoneField.backgroundColor = UIColor.white
        phoneField.isUserInteractionEnabled = false
        
        phoneIconImgView.setImage(UIImage(named: "i_list_phone"), for: .normal)
        phoneIconImgView.backgroundColor = UIColor.clear
        phoneIconImgView.addTarget(self, action: #selector(phone), for: .touchUpInside)
        phoneIconImgView.clipsToBounds = true
        
        mobileLabel.text = "MOBILE"
        mobileLabel.font = UIFont(name: "OpenSans", size: 15)
        mobileLabel.textAlignment = .left
        mobileLabel.textColor = Global.colorGray
        mobileLabel.numberOfLines = 1
        
        mobileField.textAlignment = .left
        mobileField.placeholder = "0-000-000-0000"
        mobileField.text = "1-584-453-123"
        mobileField.textColor = UIColor.black
        mobileField.returnKeyType = .done
        mobileField.keyboardType = .phonePad
        mobileField.inputAccessoryView = UIView()
        mobileField.autocorrectionType = .no
        mobileField.autocapitalizationType = .none
        mobileField.font = UIFont(name: "OpenSans-semibold", size: 17)
        mobileField.backgroundColor = UIColor.white
        mobileField.isUserInteractionEnabled = false
        
        mobileIconImgView.setImage(UIImage(named: "i_list_mobile"), for: .normal)
        mobileIconImgView.backgroundColor = UIColor.clear
        mobileIconImgView.addTarget(self, action: #selector(mobile), for: .touchUpInside)
        mobileIconImgView.clipsToBounds = true
        
        jobContactView.addSubview(jobContactLabel)
        jobContacValueView.addSubview(jobContactField)
        emailView.addSubview(emailLabel)
        emailValueView.addSubview(emailField)
        emailValueView.addSubview(emailIconImgView)
        phoneView.addSubview(phoneLabel)
        phoneValueView.addSubview(phoneField)
        phoneValueView.addSubview(phoneIconImgView)
        mobileView.addSubview(mobileLabel)
        mobileValueView.addSubview(mobileField)
        mobileValueView.addSubview(mobileIconImgView)
        
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
        jobContactField.text = contact.jobContact
        mobileField.text = contact.mobile
        phoneField.text = contact.phone
        emailField.text = contact.email
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
            
            mobileView.autoPinEdge(.top, to: .bottom, of: jobContacValueView)
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
            mobileField.autoPinEdge(.right, to: .left, of: mobileIconImgView, withOffset: -10)
            
            mobileIconImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            mobileIconImgView.autoSetDimensions(to: CGSize(width: 30, height: 30))
            mobileIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            //------------------------------------------------------------------------
            
            phoneView.autoPinEdge(.top, to: .bottom, of: mobileValueView)
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
            phoneField.autoPinEdge(.right, to: .left, of: phoneIconImgView, withOffset: -10)
            
            phoneIconImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            phoneIconImgView.autoSetDimensions(to: CGSize(width: 30, height: 30))
            phoneIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            //------------------------------------------------------------------------
            
            emailView.autoPinEdge(.top, to: .bottom, of: phoneValueView)
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
            emailField.autoPinEdge(.right, to: .left, of: emailIconImgView, withOffset: -10)
            
            emailIconImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            emailIconImgView.autoSetDimensions(to: CGSize(width: 30, height: 30))
            emailIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
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
    
    func email() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailField.text!])
            mail.setSubject("")
            mail.setMessageBody("", isHTML: false)
            mail.navigationBar.isTranslucent = false
            mail.navigationBar.barTintColor = UIColor.red
            mail.navigationBar.tintColor = Global.colorMain
            self.present(mail, animated: true, completion: nil)
        } else {
            Utils.showAlert(title: "Error", message: "You are not logged in e-mail. Please check e-mail configuration and try again", viewController: self)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func phone() {
        callNumber(phone: phoneField.text!)
    }
    
    func mobile() {
        callNumber(phone: mobileField.text!)
    }
    
    func callNumber(phone: String) {
        let components = phone.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "")
        
        let phone = "tel://" + decimalString
        let url:NSURL = NSURL(string:phone)!
        UIApplication.shared.openURL(url as URL)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
