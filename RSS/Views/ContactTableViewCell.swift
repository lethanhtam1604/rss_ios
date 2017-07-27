//
//  ContactTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/23/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    let arrowRightImgView = UIButton()
    
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
        
        nameLabel.text = "Danielle Rodriguez"
        nameLabel.font = UIFont(name: "OpenSans", size: 18)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        
        arrowRightImgView.clipsToBounds = true
        arrowRightImgView.contentMode = .scaleAspectFit
        arrowRightImgView.setImage(UIImage(named: "ArrowRight"), for: .normal)
        
        addSubview(nameLabel)
        addSubview(arrowRightImgView)
    }
    
    func bidingData(contact: Contact) {
        nameLabel.text = contact.jobContact
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true
            
            nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 22)
            nameLabel.autoPinEdge(.right, to: .left, of: arrowRightImgView, withOffset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
            
            arrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            arrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            arrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
    }
}
