//
//  AssignToStaffTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/28/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class AssignToStaffTableViewCell: UITableViewCell {

    let userIconImgView = UIImageView()
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
        backgroundColor = UIColor.white
        
        userIconImgView.clipsToBounds = true
        userIconImgView.contentMode = .scaleAspectFit
        userIconImgView.image = UIImage(named: "i_avatar_staff_male")
        
        nameLabel.text = "Jordan Walters"
        nameLabel.font = UIFont(name: "OpenSans", size: 18)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        
        addSubview(userIconImgView)
        addSubview(nameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true
            
            userIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            userIconImgView.autoSetDimensions(to: CGSize(width: 50, height: 50))
            userIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            nameLabel.autoPinEdge(.left, to: .right, of: userIconImgView, withOffset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        }
    }
    
    func bindingData(staff: User) {
        nameLabel.text = staff.name
    }
}
