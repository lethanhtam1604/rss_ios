//
//  JobHeaderTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/23/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class JobHeaderTableViewCell: UITableViewCell {

    let jobAddressView = UIView()
    let jobAddressLabel = UILabel()
    let jobAddressValueView = UIView()
    let jobAddressField = UITextField()
    let jobAddressBtn = UIButton()
    let contactView = UIView()
    let contactDetailsLabel = UILabel()
    let addBtn = UIButton(type: .custom)
    
    var constraintAdded = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.clear
        tintColor = Global.colorSignin
        
        jobAddressView.backgroundColor = UIColor.clear
        jobAddressValueView.backgroundColor = UIColor.white
        contactView.backgroundColor = UIColor.clear
        
        jobAddressLabel.text = "JOB ADDRESS"
        jobAddressLabel.font = UIFont(name: "OpenSans", size: 15)
        jobAddressLabel.textAlignment = .left
        jobAddressLabel.textColor = Global.colorGray
        jobAddressLabel.numberOfLines = 1
        
        jobAddressField.textAlignment = .left
        jobAddressField.placeholder = "Enter Job Address"
        jobAddressField.textColor = UIColor.black
        jobAddressField.returnKeyType = .done
        jobAddressField.keyboardType = .namePhonePad
        jobAddressField.inputAccessoryView = UIView()
        jobAddressField.autocorrectionType = .no
        jobAddressField.autocapitalizationType = .none
        jobAddressField.font = UIFont(name: "OpenSans", size: 17)
        jobAddressField.backgroundColor = UIColor.white
        jobAddressField.isUserInteractionEnabled = false
        
        jobAddressBtn.backgroundColor = UIColor.clear
        
        contactDetailsLabel.text = "CONTACT DETAILS"
        contactDetailsLabel.font = UIFont(name: "OpenSans", size: 15)
        contactDetailsLabel.textAlignment = .left
        contactDetailsLabel.textColor = Global.colorGray
        contactDetailsLabel.numberOfLines = 1
        
        addBtn.backgroundColor = UIColor.clear
        addBtn.clipsToBounds = true
        addBtn.contentMode = .scaleAspectFit
        let tintedImage = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        addBtn.setImage(tintedImage, for: .normal)
        addBtn.setImage(UIImage(named: "add"), for: .highlighted)
        addBtn.tintColor = Global.colorSignin
        
        jobAddressView.addSubview(jobAddressLabel)
        jobAddressValueView.addSubview(jobAddressField)
        jobAddressValueView.addSubview(jobAddressBtn)
        contactView.addSubview(contactDetailsLabel)
        contactView.addSubview(addBtn)
        
        contentView.addSubview(jobAddressView)
        contentView.addSubview(jobAddressValueView)
        contentView.addSubview(contactView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true
            
            let height: CGFloat = 50
            
            //------------------------------------------------------------------------
            
            jobAddressView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            jobAddressView.autoPinEdge(toSuperviewEdge: .right)
            jobAddressView.autoPinEdge(toSuperviewEdge: .left)
            jobAddressView.autoSetDimension(.height, toSize: height)
            
            jobAddressLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            jobAddressLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            jobAddressLabel.autoSetDimension(.height, toSize: 20)
            jobAddressLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            jobAddressValueView.autoPinEdge(.top, to: .bottom, of: jobAddressView)
            jobAddressValueView.autoPinEdge(toSuperviewEdge: .right)
            jobAddressValueView.autoPinEdge(toSuperviewEdge: .left)
            jobAddressValueView.autoSetDimension(.height, toSize: height)
            
            jobAddressField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            jobAddressField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            jobAddressField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            jobAddressField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            jobAddressBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            jobAddressBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            jobAddressBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            jobAddressBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            
            //------------------------------------------------------------------------
            
            contactView.autoPinEdge(.top, to: .bottom, of: jobAddressValueView)
            contactView.autoPinEdge(toSuperviewEdge: .right)
            contactView.autoPinEdge(toSuperviewEdge: .left)
            contactView.autoSetDimension(.height, toSize: height)
            
            contactDetailsLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            contactDetailsLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            contactDetailsLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            contactDetailsLabel.autoPinEdge(.right, to: .left, of: addBtn, withOffset: 10)
            
            addBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            addBtn.autoSetDimensions(to: CGSize(width: 50, height: 50))
            addBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
    }
}
