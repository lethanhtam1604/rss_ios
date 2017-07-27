//
//  ClientNameTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/25/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class ClientNameTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    let newLabel = UILabel()
    
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
        
        nameLabel.font = UIFont(name: "OpenSans", size: 14)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        
        newLabel.text = "New"
        newLabel.font = UIFont(name: "OpenSans", size: 12)
        newLabel.textAlignment = .right
        newLabel.textColor = UIColor.black
        newLabel.numberOfLines = 1
        
        addSubview(nameLabel)
        addSubview(newLabel)
    }
    
    func bidingData(index: Int, client: Client, count: Int) {
        
        if index == 0 {
            nameLabel.text = client.name
            backgroundColor = UIColor.clear
            newLabel.isHidden = true
        }
        else if index == count - 1 {
            nameLabel.text = client.name
            backgroundColor = Global.colorSignin.withAlphaComponent(0.4)
            newLabel.isHidden = false
        }
        else {
            nameLabel.text = client.name
            backgroundColor = UIColor.white
            newLabel.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true
            
            newLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            newLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            newLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 15)
            newLabel.autoSetDimension(.width, toSize: 30)
            
            nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            nameLabel.autoPinEdge(.right, to: .left, of: newLabel, withOffset: -5)
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 15)
        }
    }
}
