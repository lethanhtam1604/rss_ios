//
//  ClientTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/23/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {

    let userIconImgView = UIImageView()
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
        
        userIconImgView.clipsToBounds = true
        userIconImgView.contentMode = .scaleAspectFit
        userIconImgView.image = UIImage(named: "i_avatar_client_male")
        
        nameLabel.text = "Jonathan Santos"
        nameLabel.font = UIFont(name: "OpenSans", size: 18)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        
        arrowRightImgView.clipsToBounds = true
        arrowRightImgView.contentMode = .scaleAspectFit
        arrowRightImgView.setImage(UIImage(named: "ArrowRight"), for: .normal)
        
        addSubview(userIconImgView)
        addSubview(nameLabel)
        addSubview(arrowRightImgView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true
            
            userIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            userIconImgView.autoSetDimensions(to: CGSize(width: 50, height: 50))
            userIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            nameLabel.autoPinEdge(.left, to: .right, of: userIconImgView, withOffset: 10)
            nameLabel.autoPinEdge(.right, to: .left, of: arrowRightImgView, withOffset: -10)
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
            
            arrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            arrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            arrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
    }
    
    func bindingData(client: Client) {
        nameLabel.text = client.name
    }
}
