//
//  StaffJobTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/1/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import Firebase

class StaffJobTableViewCell: UITableViewCell {

    let lineView = UIView()
    let jobStatusImgView = UIImageView()
    let clientNameLabel = UILabel()
    let addressLabel = UILabel()
    let jobNumberLabel = UILabel()
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
        addSubview(abstractView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
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
            
            abstractView.autoPinEdge(toSuperviewEdge: .top)
            abstractView.autoPinEdge(toSuperviewEdge: .left)
            abstractView.autoPinEdge(toSuperviewEdge: .right)
            abstractView.autoPinEdge(toSuperviewEdge: .bottom)
            
            circleRed.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            circleRed.autoPinEdge(.top, to: .bottom, of: jobNumberLabel, withOffset: 8)
            circleRed.autoSetDimension(.height, toSize: 20)
            circleRed.autoSetDimension(.width, toSize: 20)
            
            numberOfNoti.autoAlignAxis(toSuperviewAxis: .horizontal)
            numberOfNoti.autoAlignAxis(toSuperviewAxis: .vertical)
            numberOfNoti.autoSetDimension(.height, toSize: 10)
            numberOfNoti.autoSetDimension(.width, toSize: 10)
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
        
        if job.accept.seen == false || job.reject.seen == false {
            circleRed.isHidden = false
        }
        else {
            circleRed.isHidden = true
        }
        
        jobNumberLabel.text = "#" + String(job.number!)
        
        DatabaseHelper.shared.getClient(clientId: job.clientId!, userId: (FIRAuth.auth()!.currentUser?.uid)!) {
            client in
            
            if client != nil {
                self.clientNameLabel.text = client?.name
                self.addressLabel.text = client?.location.fullAddress
            }
            
            DatabaseHelper.shared.observeClients(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
                newClient in
                if newClient.id == job.clientId! {
                    self.clientNameLabel.text = newClient.name
                    self.addressLabel.text = newClient.location.fullAddress
                }
            }
        }
    }
}

