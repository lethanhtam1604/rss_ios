//
//  JobFooterTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/24/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import GrowingTextView

class JobFooterTableViewCell: UITableViewCell {

    let jobDescriptionView = UIView()
    let jobDescriptionLabel = UILabel()
    let jobDescriptionValueTV = UITextView()

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
        contentView.backgroundColor = UIColor.white
        
        jobDescriptionView.backgroundColor = Global.colorBg
        
        jobDescriptionLabel.text = "JOB DESCRIPTION"
        jobDescriptionLabel.font = UIFont(name: "OpenSans", size: 15)
        jobDescriptionLabel.textAlignment = .left
        jobDescriptionLabel.textColor = Global.colorGray
        jobDescriptionLabel.numberOfLines = 1
        
        jobDescriptionValueTV.text = "It was a humorously perilous business for both of us. For, before we proceed further, it."
        jobDescriptionValueTV.font = UIFont(name: "OpenSans", size: 14)
        jobDescriptionValueTV.textAlignment = .left
        jobDescriptionValueTV.textColor = UIColor.black
        jobDescriptionValueTV.placeholderText = "Enter job description"
        jobDescriptionView.addSubview(jobDescriptionLabel)
        
        contentView.addSubview(jobDescriptionView)
        contentView.addSubview(jobDescriptionValueTV)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true
            
            let height: CGFloat = 50
            
            //------------------------------------------------------------------------
            
            jobDescriptionView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            jobDescriptionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            jobDescriptionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            jobDescriptionView.autoSetDimension(.height, toSize: height)
            
            jobDescriptionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            jobDescriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            jobDescriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            jobDescriptionLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------
        
            jobDescriptionValueTV.autoPinEdge(.top, to: .bottom, of: jobDescriptionView, withOffset: 10)
            jobDescriptionValueTV.autoSetDimension(.height, toSize: 80)
            jobDescriptionValueTV.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            jobDescriptionValueTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
        }
    }
}
