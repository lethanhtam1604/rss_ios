//
//  JobDetailHeaderTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/25/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class JobDetailHeaderTableViewCell: UITableViewCell {
    
    let jobView = UIView()
    let jobBorderView = UIView()
    let lineView = UIView()
    let jobStatusImgView = UIImageView()
    let listInfoBtn = UIButton()
    let circleRed = UIView()
    let clientNameLabel = UILabel()
    let contactNameLabel = UILabel()
    let addressLabel = UILabel()
    let assignedToLabel = UILabel()
    let startJobBtn = UIButton()
    
    let checkListHeaderView = UIView()
    let checkListTitleLabel = UILabel()
    
    let checkListView = UIView()
    let checkListAbstractView = UIView()
    let checkListIconImgView = UIImageView()
    let checkListArrowRightImgView = UIImageView()
    let checkListLabel = UILabel()
    
    let jobDescriptionView = UIView()
    let jobDescriptionLabel = UILabel()
    
    let jobDescriptionValueView = UIView()
    let jobDescriptionValueTV = UITextView()
    
    let contactsHeaderView = UIView()
    let contactsTitleLabel = UILabel()

    var constraintAdded = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func commonInit() {
        backgroundColor = Global.colorBg
        
        jobView.backgroundColor = UIColor.white
        checkListHeaderView.backgroundColor = UIColor.clear
        checkListView.backgroundColor = UIColor.white
        jobDescriptionView.backgroundColor = UIColor.clear
        jobDescriptionValueView.backgroundColor = UIColor.white
        contactsHeaderView.backgroundColor = UIColor.clear
        
        checkListAbstractView.touchHighlightingStyle = .lightBackground
        checkListAbstractView.backgroundColor = UIColor.clear

        lineView.backgroundColor = Global.colorP
        
        jobBorderView.backgroundColor = Global.colorSeparator
        
        jobStatusImgView.clipsToBounds = true
        jobStatusImgView.contentMode = .scaleAspectFit
        jobStatusImgView.image = UIImage(named: "i_job_overdue")
        
        let exclamationImg = UIImage(named: "i_list_info")
        let exclamationtTintedImg = exclamationImg?.withRenderingMode(.alwaysTemplate)
        listInfoBtn.setImage(exclamationtTintedImg, for: .normal)
        listInfoBtn.backgroundColor = UIColor.clear
        listInfoBtn.clipsToBounds = true
        listInfoBtn.tintColor = Global.colorSignin
        
        clientNameLabel.text = "Johnny Hoffman"
        clientNameLabel.font = UIFont(name: "OpenSans-semibold", size: 18)
        clientNameLabel.textAlignment = .left
        clientNameLabel.textColor = UIColor.black
        clientNameLabel.lineBreakMode = .byTruncatingTail
        clientNameLabel.numberOfLines = 1
        
        contactNameLabel.text = "Contact"
        contactNameLabel.font = UIFont(name: "OpenSans", size: 14)
        contactNameLabel.textAlignment = .left
        contactNameLabel.textColor = Global.colorGray
        contactNameLabel.lineBreakMode = .byTruncatingTail
        contactNameLabel.numberOfLines = 1
        
        addressLabel.text = "Address"
        addressLabel.font = UIFont(name: "OpenSans", size: 14)
        addressLabel.textAlignment = .left
        addressLabel.textColor = Global.colorGray
        addressLabel.lineBreakMode = .byTruncatingTail
        addressLabel.numberOfLines = 2
        
        assignedToLabel.text = "Assigned To:"
        assignedToLabel.font = UIFont(name: "OpenSans", size: 14)
        assignedToLabel.textAlignment = .left
        assignedToLabel.textColor = Global.colorGray
        assignedToLabel.lineBreakMode = .byTruncatingTail
        assignedToLabel.numberOfLines = 2
        
        startJobBtn.setTitle("START JOB", for: .normal)
        startJobBtn.backgroundColor = Global.colorStartJob
        startJobBtn.setTitleColor(UIColor.white, for: .normal)
        startJobBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        startJobBtn.layer.cornerRadius = 5
        startJobBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        startJobBtn.clipsToBounds = true
        startJobBtn.titleLabel?.lineBreakMode = .byWordWrapping
        startJobBtn.titleLabel?.textAlignment = .center
        
        checkListTitleLabel.text = "CHECKLIST"
        checkListTitleLabel.font = UIFont(name: "OpenSans", size: 15)
        checkListTitleLabel.textAlignment = .left
        checkListTitleLabel.textColor = Global.colorGray
        checkListTitleLabel.numberOfLines = 1
        
        checkListIconImgView.clipsToBounds = true
        checkListIconImgView.contentMode = .scaleAspectFit
        checkListIconImgView.image = UIImage(named: "Rectangle")
        
        checkListLabel.text = "Check list"
        checkListLabel.font = UIFont(name: "OpenSans-semibold", size: 17)
        checkListLabel.textAlignment = .left
        checkListLabel.textColor = UIColor.black
        checkListLabel.numberOfLines = 1
        
        checkListArrowRightImgView.clipsToBounds = true
        checkListArrowRightImgView.contentMode = .scaleAspectFit
        checkListArrowRightImgView.image = UIImage(named: "ArrowRight")
        
        jobDescriptionLabel.text = "JOB DESCRIPTION"
        jobDescriptionLabel.font = UIFont(name: "OpenSans", size: 15)
        jobDescriptionLabel.textAlignment = .left
        jobDescriptionLabel.textColor = Global.colorGray
        jobDescriptionLabel.numberOfLines = 1
        
        jobDescriptionValueTV.text = "It was a humorously perilous business for both of us. For, before we proceed further, it."
        jobDescriptionValueTV.font = UIFont(name: "OpenSans", size: 14)
        jobDescriptionValueTV.textAlignment = .left
        jobDescriptionValueTV.textColor = UIColor.black
        jobDescriptionValueTV.isEditable = false
        
        contactsTitleLabel.text = "CONTACTS"
        contactsTitleLabel.font = UIFont(name: "OpenSans", size: 15)
        contactsTitleLabel.textAlignment = .left
        contactsTitleLabel.textColor = Global.colorGray
        contactsTitleLabel.numberOfLines = 1
        
        circleRed.backgroundColor = UIColor.red
        circleRed.layer.cornerRadius = 5
        circleRed.isHidden = true
        
        jobView.addSubview(jobBorderView)
        jobView.addSubview(lineView)
        jobView.addSubview(jobStatusImgView)
        jobView.addSubview(listInfoBtn)
        jobView.addSubview(circleRed)
        jobView.addSubview(clientNameLabel)
        jobView.addSubview(contactNameLabel)
        jobView.addSubview(addressLabel)
        jobView.addSubview(assignedToLabel)
        jobView.addSubview(startJobBtn)
        
        checkListHeaderView.addSubview(checkListTitleLabel)
        
        checkListView.addSubview(checkListIconImgView)
        checkListView.addSubview(checkListLabel)
        checkListView.addSubview(checkListArrowRightImgView)
        checkListView.addSubview(checkListAbstractView)
        
        jobDescriptionView.addSubview(jobDescriptionLabel)
        jobDescriptionValueView.addSubview(jobDescriptionValueTV)
        
        contactsHeaderView.addSubview(contactsTitleLabel)
       
        contentView.addSubview(jobView)
        contentView.addSubview(checkListHeaderView)
        contentView.addSubview(checkListView)
        contentView.addSubview(jobDescriptionView)
        contentView.addSubview(jobDescriptionValueView)
        contentView.addSubview(contactsHeaderView)
        
        setNeedsUpdateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !constraintAdded {
            constraintAdded = true
            
            let alpha: CGFloat = 30
            
            //----------------------------------------------------------------------------------
            
            jobView.autoPinEdge(toSuperviewEdge: .top)
            jobView.autoPinEdge(toSuperviewEdge: .right)
            jobView.autoPinEdge(toSuperviewEdge: .left)
            jobView.autoSetDimension(.height, toSize: 20 + 20 + 2  + 20 + 2 + 20 + 2 + 40 + 10 + 45 + 20 + 20)
            
            jobBorderView.autoPinEdge(toSuperviewEdge: .top)
            jobBorderView.autoPinEdge(toSuperviewEdge: .right)
            jobBorderView.autoPinEdge(toSuperviewEdge: .left)
            jobBorderView.autoSetDimension(.height, toSize: 0.5)
            
            lineView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            lineView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            lineView.autoPinEdge(toSuperviewEdge: .left, withInset: 28)
            lineView.autoSetDimension(.width, toSize: 3)
            
            jobStatusImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            jobStatusImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            jobStatusImgView.autoSetDimensions(to: CGSize(width: 40, height: 40))
            
            clientNameLabel.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            clientNameLabel.autoPinEdge(.right, to: .left, of: listInfoBtn, withOffset: 10)
            clientNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
            clientNameLabel.autoSetDimension(.height, toSize: 30)
            
            listInfoBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
            listInfoBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            listInfoBtn.autoSetDimensions(to: CGSize(width: 50, height: 50))
            
            circleRed.autoPinEdge(toSuperviewEdge: .right, withInset: 13)
            circleRed.autoPinEdge(toSuperviewEdge: .top, withInset: 21)
            circleRed.autoSetDimension(.height, toSize: 10)
            circleRed.autoSetDimension(.width, toSize: 10)
            
            contactNameLabel.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            contactNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            contactNameLabel.autoPinEdge(.top, to: .bottom, of: clientNameLabel, withOffset: 2)
            
            addressLabel.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            addressLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            addressLabel.autoPinEdge(.top, to: .bottom, of: contactNameLabel, withOffset: 2)
            
            assignedToLabel.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            assignedToLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            assignedToLabel.autoPinEdge(.top, to: .bottom, of: addressLabel, withOffset: 2)
            
            startJobBtn.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            startJobBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
            startJobBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            startJobBtn.autoSetDimension(.height, toSize: 45)
            
            //----------------------------------------------------------------------------------
            checkListHeaderView.autoPinEdge(.top, to: .bottom, of: jobView, withOffset: 0)
            checkListHeaderView.autoPinEdge(toSuperviewEdge: .right)
            checkListHeaderView.autoPinEdge(toSuperviewEdge: .left)
            checkListHeaderView.autoSetDimension(.height, toSize: 50)
            
            checkListTitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            checkListTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            checkListTitleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            checkListTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 28)
            
            //----------------------------------------------------------------------------------
            
            checkListView.autoPinEdge(.top, to: .bottom, of: checkListHeaderView, withOffset: 0)
            checkListView.autoPinEdge(toSuperviewEdge: .right)
            checkListView.autoPinEdge(toSuperviewEdge: .left)
            checkListView.autoSetDimension(.height, toSize: 50)
            
            checkListIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            checkListIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
            checkListIconImgView.autoSetDimensions(to: CGSize(width: 20, height: 20))
            
            checkListLabel.autoPinEdge(.left, to: .right, of: checkListIconImgView, withOffset: 8)
            checkListLabel.autoPinEdge(toSuperviewEdge: .top)
            checkListLabel.autoPinEdge(toSuperviewEdge: .bottom)
            checkListLabel.autoPinEdge(.right, to: .left, of: checkListArrowRightImgView, withOffset: 5)
            
            checkListArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            checkListArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            checkListArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            checkListAbstractView.autoPinEdge(toSuperviewEdge: .top)
            checkListAbstractView.autoPinEdge(toSuperviewEdge: .right)
            checkListAbstractView.autoPinEdge(toSuperviewEdge: .left)
            checkListAbstractView.autoPinEdge(toSuperviewEdge: .bottom)
            
            //------------------------------------------------------------------------
            
            jobDescriptionView.autoPinEdge(.top, to: .bottom, of: checkListView, withOffset: 0)
            jobDescriptionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            jobDescriptionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            jobDescriptionView.autoSetDimension(.height, toSize: 50)
            
            jobDescriptionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            jobDescriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 28)
            jobDescriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            jobDescriptionLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            
            //------------------------------------------------------------------------
            
            jobDescriptionValueView.autoPinEdge(.top, to: .bottom, of: jobDescriptionView, withOffset: 0)
            jobDescriptionValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            jobDescriptionValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            jobDescriptionValueView.autoSetDimension(.height, toSize: 100)
            
            jobDescriptionValueTV.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            jobDescriptionValueTV.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            jobDescriptionValueTV.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
            jobDescriptionValueTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            contactsHeaderView.autoPinEdge(.top, to: .bottom, of: jobDescriptionValueView, withOffset: 0)
            contactsHeaderView.autoPinEdge(toSuperviewEdge: .right)
            contactsHeaderView.autoPinEdge(toSuperviewEdge: .left)
            contactsHeaderView.autoSetDimension(.height, toSize: 50)
            
            contactsTitleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            contactsTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            contactsTitleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            contactsTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 28)
        }
    }
}
