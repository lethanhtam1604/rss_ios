//
//  FilterHeaderTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/26/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class FilterHeaderTableViewCell: UITableViewCell {

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

        nameLabel.text = "JOBS"
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
