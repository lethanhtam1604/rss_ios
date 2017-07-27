//
//  ClientJobHeaderTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/25/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class ClientJobHeaderTableViewCell: UITableViewCell {

    let clientView = UIView()
    let clientNameLabel = UILabel()
    let clientValueView = UIView()
    let clientNameValueField = UITextField()
    
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
        
        clientView.backgroundColor = UIColor.clear
        clientValueView.backgroundColor = UIColor.white
        
        clientNameLabel.text = "CLIENTS NAME"
        clientNameLabel.font = UIFont(name: "OpenSans", size: 15)
        clientNameLabel.textAlignment = .left
        clientNameLabel.textColor = Global.colorGray
        clientNameLabel.numberOfLines = 1
        
        clientNameValueField.textAlignment = .left
        clientNameValueField.placeholder = "Enter Clients Name"
        clientNameValueField.text = ""
        clientNameValueField.textColor = UIColor.black
        clientNameValueField.returnKeyType = .search
        clientNameValueField.keyboardType = .namePhonePad
        clientNameValueField.inputAccessoryView = UIView()
        clientNameValueField.autocorrectionType = .no
        clientNameValueField.autocapitalizationType = .none
        clientNameValueField.font = UIFont(name: "OpenSans-semibold", size: 17)
        clientNameValueField.backgroundColor = UIColor.white
        
        clientView.addSubview(clientNameLabel)
        clientValueView.addSubview(clientNameValueField)
        
        contentView.addSubview(clientView)
        contentView.addSubview(clientValueView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true
            
            let height: CGFloat = 50
            
            //------------------------------------------------------------------------
            
            clientView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            clientView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            clientView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            clientView.autoSetDimension(.height, toSize: height)
            
            clientNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            clientNameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            clientNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            clientNameLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------
            
            clientValueView.autoPinEdge(.top, to: .bottom, of: clientView)
            clientValueView.autoPinEdge(toSuperviewEdge: .right)
            clientValueView.autoPinEdge(toSuperviewEdge: .left)
            clientValueView.autoSetDimension(.height, toSize: height)
            
            clientNameValueField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            clientNameValueField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            clientNameValueField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            clientNameValueField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
        }
    }
}
