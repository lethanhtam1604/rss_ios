//
//  PartTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/29/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class PartTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    let quantityLabel = UILabel()
    
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
        
        nameLabel.text = "Part"
        nameLabel.font = UIFont(name: "OpenSans-semibold", size: 18)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        
        quantityLabel.text = "0"
        quantityLabel.font = UIFont(name: "OpenSans-semibold", size: 18)
        quantityLabel.textAlignment = .right
        quantityLabel.textColor = UIColor.black
        quantityLabel.lineBreakMode = .byWordWrapping
        quantityLabel.numberOfLines = 0
        
        addSubview(nameLabel)
        addSubview(quantityLabel)
    }
    
    func bidingData(part: Part) {
        nameLabel.text = part.name
        quantityLabel.text = String(part.quantity!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true
            
            nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 22)
            nameLabel.autoPinEdge(.right, to: .left, of: quantityLabel, withOffset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
            
            quantityLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            quantityLabel.autoSetDimension(.width, toSize: 30)
            quantityLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
            quantityLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        }
    }
}
