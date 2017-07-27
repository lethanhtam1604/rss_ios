//
//  FilterTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/24/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    let borderView = UIView()
    
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
        backgroundColor = UIColor.white
        borderView.backgroundColor = Global.colorSeparator
        
        nameLabel.text = "All Jobs"
        nameLabel.font = UIFont(name: "OpenSans", size: 18)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        
        addSubview(nameLabel)
        addSubview(borderView)
    }
    
    func bidingData(text: String) {
        nameLabel.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true
            
            nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 15)
            
            borderView.autoSetDimension(.height, toSize: 0.5)
            borderView.autoPinEdge(toSuperviewEdge: .bottom)
            borderView.autoPinEdge(toSuperviewEdge: .left)
            borderView.autoPinEdge(toSuperviewEdge: .right)
        }
    }
}
