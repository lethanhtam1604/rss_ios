//
//  InvitationTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/1/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import Firebase

class InvitationTableViewCell: UITableViewCell {
    
    let lineView = UIView()
    let jobStatusImgView = UIImageView()
    let clientNameLabel = UILabel()
    let addressLabel = UILabel()
    let jobNumberLabel = UILabel()
    let timeToAccept = UILabel()
    let acceptBtn = UIButton()
    let rejectBtn = UIButton()
    let abstractView = UIView()

    var circleRed = UIView()
    var numberOfNoti = UILabel()
    
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
        backgroundColor = UIColor.white
        
        abstractView.backgroundColor = UIColor.clear
        abstractView.touchHighlightingStyle = .lightBackground
        
        lineView.backgroundColor = Global.colorC
        
        jobStatusImgView.clipsToBounds = true
        jobStatusImgView.contentMode = .scaleAspectFit
        jobStatusImgView.image = UIImage(named: "i_job_complete")
        
        clientNameLabel.text = "Johnny Hoffman"
        clientNameLabel.font = UIFont(name: "OpenSans-semibold", size: 18)
        clientNameLabel.textAlignment = .left
        clientNameLabel.textColor = UIColor.black
        clientNameLabel.lineBreakMode = .byTruncatingTail
        clientNameLabel.numberOfLines = 1
        
        jobNumberLabel.text = "#101"
        jobNumberLabel.font = UIFont(name: "OpenSans", size: 17)
        jobNumberLabel.textAlignment = .right
        jobNumberLabel.textColor = Global.colorGray
        jobNumberLabel.lineBreakMode = .byWordWrapping
        jobNumberLabel.numberOfLines = 0
        
        addressLabel.text = "Lake Leorabury"
        addressLabel.font = UIFont(name: "OpenSans", size: 14)
        addressLabel.textAlignment = .left
        addressLabel.textColor = Global.colorGray
        addressLabel.lineBreakMode = .byTruncatingTail
        addressLabel.numberOfLines = 2
        
        timeToAccept.text = "Time to Accept"
        timeToAccept.font = UIFont(name: "OpenSans", size: 14)
        timeToAccept.textAlignment = .left
        timeToAccept.textColor = Global.colorGray
        timeToAccept.lineBreakMode = .byTruncatingTail
        timeToAccept.numberOfLines = 1
        
        acceptBtn.setTitle("ACCEPT", for: .normal)
        acceptBtn.backgroundColor = Global.colorStartJob
        acceptBtn.setTitleColor(UIColor.white, for: .normal)
        acceptBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        acceptBtn.layer.cornerRadius = 5
        acceptBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        acceptBtn.clipsToBounds = true
        acceptBtn.titleLabel?.lineBreakMode = .byWordWrapping
        acceptBtn.titleLabel?.textAlignment = .center
        
        rejectBtn.setTitle("REJECT", for: .normal)
        rejectBtn.backgroundColor = Global.colorU
        rejectBtn.setTitleColor(UIColor.white, for: .normal)
        rejectBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        rejectBtn.layer.cornerRadius = 5
        rejectBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        rejectBtn.clipsToBounds = true
        rejectBtn.titleLabel?.lineBreakMode = .byWordWrapping
        rejectBtn.titleLabel?.textAlignment = .center
        
        circleRed.layer.cornerRadius = 10
        circleRed.backgroundColor = UIColor.red
        
        numberOfNoti.text = "N"
        numberOfNoti.font = UIFont(name: "OpenSans", size: 14)
        numberOfNoti.textAlignment = .center
        numberOfNoti.textColor = UIColor.white
        
        addSubview(lineView)
        addSubview(jobStatusImgView)
        addSubview(clientNameLabel)
        addSubview(jobNumberLabel)
        circleRed.addSubview(numberOfNoti)
        addSubview(circleRed)
        addSubview(addressLabel)
        addSubview(timeToAccept)
        addSubview(abstractView)
        addSubview(acceptBtn)
        addSubview(rejectBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true
            
            let alpha: CGFloat = 35
            
            lineView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            lineView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            lineView.autoPinEdge(toSuperviewEdge: .left, withInset: 33)
            lineView.autoSetDimension(.width, toSize: 3)
            
            jobStatusImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            jobStatusImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
            jobStatusImgView.autoSetDimensions(to: CGSize(width: 40, height: 40))
            
            clientNameLabel.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            clientNameLabel.autoPinEdge(.right, to: .left, of: jobNumberLabel, withOffset: -5)
            clientNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            
            jobNumberLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            jobNumberLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            jobNumberLabel.autoSetDimension(.height, toSize: 25)
            jobNumberLabel.autoSetDimension(.width, toSize: 50)
            
            addressLabel.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            addressLabel.autoPinEdge(.right, to: .left, of: circleRed, withOffset: -5)
            addressLabel.autoPinEdge(.top, to: .bottom, of: clientNameLabel, withOffset: 2)
            
            timeToAccept.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            timeToAccept.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            timeToAccept.autoPinEdge(.top, to: .bottom, of: addressLabel, withOffset: 2)
            
            acceptBtn.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            acceptBtn.autoMatch(.width, to: .width, of: rejectBtn)
            acceptBtn.autoPinEdge(.bottom, to: .bottom, of: rejectBtn)

            rejectBtn.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            rejectBtn.autoPinEdge(.left, to: .right, of: acceptBtn, withOffset: 10)
            rejectBtn.autoMatch(.width, to: .width, of: acceptBtn)
            rejectBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)

            circleRed.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            circleRed.autoPinEdge(.top, to: .bottom, of: jobNumberLabel, withOffset: 8)
            circleRed.autoSetDimension(.height, toSize: 20)
            circleRed.autoSetDimension(.width, toSize: 20)
            
            numberOfNoti.autoAlignAxis(toSuperviewAxis: .horizontal)
            numberOfNoti.autoAlignAxis(toSuperviewAxis: .vertical)
            numberOfNoti.autoSetDimension(.height, toSize: 10)
            numberOfNoti.autoSetDimension(.width, toSize: 10)
            
            abstractView.autoPinEdge(toSuperviewEdge: .top)
            abstractView.autoPinEdge(toSuperviewEdge: .left)
            abstractView.autoPinEdge(toSuperviewEdge: .right)
            abstractView.autoPinEdge(toSuperviewEdge: .bottom)
        }
    }
    
    func bidingData(job: Job) {
        
        if job.jobStatus == JobStatus.UnSchedule.rawValue {
            jobStatusImgView.image = UIImage(named: "i_job_overdue")
            lineView.backgroundColor = Global.colorU
        }
        else if job.jobStatus == JobStatus.Schedule.rawValue {
            jobStatusImgView.image = UIImage(named: "i_job_schedule")
            lineView.backgroundColor = Global.colorS
        }
        else if job.jobStatus == JobStatus.InProgress.rawValue {
            jobStatusImgView.image = UIImage(named: "i_job_pending")
            lineView.backgroundColor = Global.colorP
        }
        else {
            jobStatusImgView.image = UIImage(named: "i_job_complete")
            lineView.backgroundColor = Global.colorC
        }
        
        if job.invitationSeen == false {
            circleRed.isHidden = false
        }
        else {
            circleRed.isHidden = true
        }
        
        jobNumberLabel.text = "#" + String(job.number!)
        timeToAccept.text = job.assign.acceptanceDate
        
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            if user != nil {
                DatabaseHelper.shared.getClient(clientId:job.clientId!, userId: (user?.adminId)!) {
                    client in
                    
                    if client != nil {
                        self.clientNameLabel.text = client?.name
                        self.addressLabel.text = client?.location.fullAddress
                    }
                    
                    DatabaseHelper.shared.observeClients(userId: (user?.adminId)!) {
                        newClient in
                        if newClient.id == job.clientId! {
                            self.clientNameLabel.text = newClient.name
                            self.addressLabel.text = newClient.location.fullAddress
                        }
                    }
                }
                
            }
        }
    }
}
