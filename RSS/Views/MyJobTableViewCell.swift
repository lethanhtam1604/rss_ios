//
//  MyJobTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/1/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import Firebase

class MyJobTableViewCell: UITableViewCell {

    let lineView = UIView()
    let jobStatusImgView = UIImageView()
    let clientNameLabel = UILabel()
    let addressLabel = UILabel()
    let jobNumberLabel = UILabel()
    let abstractView = UIView()
    
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
        jobNumberLabel.lineBreakMode = .byTruncatingTail
        jobNumberLabel.numberOfLines = 0
        
        addressLabel.text = "Lake Leorabury"
        addressLabel.font = UIFont(name: "OpenSans", size: 14)
        addressLabel.textAlignment = .left
        addressLabel.textColor = Global.colorGray
        addressLabel.lineBreakMode = .byTruncatingTail
        addressLabel.numberOfLines = 2
        
        addSubview(lineView)
        addSubview(jobStatusImgView)
        addSubview(clientNameLabel)
        addSubview(jobNumberLabel)
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
            addressLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            addressLabel.autoPinEdge(.top, to: .bottom, of: clientNameLabel, withOffset: 2)
            
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
        
        jobNumberLabel.text = "#" + String(job.number!)
        
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            if user != nil {
                DatabaseHelper.shared.getClient(clientId:job.clientId!, userId: (user?.adminId)!) {
                    client in
                    
                    if client != nil {
                        self.clientNameLabel.text = client?.name
                        self.addressLabel.text = client?.location.fullAddress
                        job.clientName = client?.name
                        job.location = client?.location ?? Location()
                    }
                    
                    DatabaseHelper.shared.observeClients(userId: (user?.adminId)!) {
                        newClient in
                        if newClient.id == job.clientId! {
                            self.clientNameLabel.text = newClient.name
                            self.addressLabel.text = newClient.location.fullAddress
                            job.clientName = newClient.name
                            job.location = newClient.location
                        }
                    }
                }
            }
        }
    }
}
