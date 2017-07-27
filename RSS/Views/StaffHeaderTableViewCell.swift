//
//  StaffHeaderTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/1/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class StaffHeaderTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
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
        
        nameLabel.text = "UNSCHEDULE"
        nameLabel.font = UIFont(name: "OpenSans", size: 15)
        nameLabel.textAlignment = .left
        nameLabel.textColor = Global.colorGray
        nameLabel.numberOfLines = 1
        
        contentView.addSubview(nameLabel)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true
            
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
        }
    }
}
