//
//  JobTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/23/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import Firebase

class JobTableViewCell: UITableViewCell {
    
    let lineView = UIView()
    let jobStatusImgView = UIImageView()
    let clientNameLabel = UILabel()
    let addressLabel = UILabel()
    let assignedToLabel = UILabel()
    let jobNumberLabel = UILabel()
    let abstractView = UIView()
    
    var constraintAdded = false
    
    var circleRed = UIView()
    var numberOfNoti = UILabel()
    
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
        
        clientNameLabel.text = ""
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
        
        addressLabel.text = ""
        addressLabel.font = UIFont(name: "OpenSans", size: 14)
        addressLabel.textAlignment = .left
        addressLabel.textColor = Global.colorGray
        addressLabel.lineBreakMode = .byTruncatingTail
        addressLabel.numberOfLines = 2
        
        assignedToLabel.text = "Assigned To: "
        assignedToLabel.font = UIFont(name: "OpenSans", size: 14)
        assignedToLabel.textAlignment = .left
        assignedToLabel.textColor = Global.colorGray
        assignedToLabel.lineBreakMode = .byTruncatingTail
        assignedToLabel.numberOfLines = 2
        
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
        addSubview(addressLabel)
        addSubview(assignedToLabel)
        circleRed.addSubview(numberOfNoti)
        addSubview(circleRed)
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
            
            assignedToLabel.autoPinEdge(.left, to: .right, of: lineView, withOffset: alpha)
            assignedToLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 35)
            assignedToLabel.autoPinEdge(.top, to: .bottom, of: addressLabel, withOffset: 2)
            
            abstractView.autoPinEdge(toSuperviewEdge: .top)
            abstractView.autoPinEdge(toSuperviewEdge: .left)
            abstractView.autoPinEdge(toSuperviewEdge: .right)
            abstractView.autoPinEdge(toSuperviewEdge: .bottom)
            
            circleRed.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            circleRed.autoPinEdge(.top, to: .bottom, of: jobNumberLabel, withOffset: 10)
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
        
        jobNumberLabel.text = "#" + String(job.number!)
        
        if job.accept.seen == false || job.reject.seen == false {
            circleRed.isHidden = false
        }
        else {
            circleRed.isHidden = true
        }
        
        DatabaseHelper.shared.getUser(id: job.assign.staffId ?? "") {
            user in
            if user != nil {
                self.updateUser(job: job, user: user!)
            }
            else {
                self.assignedToLabel.text = "Assigned To: None"
            }
            
            DatabaseHelper.shared.observeUsers() {
                newUser in
                if (newUser.id == job.assign.staffId) {
                    self.updateUser(job: job, user: newUser)
                }
            }
        }
        
        DatabaseHelper.shared.getClient(clientId: job.clientId!, userId: (FIRAuth.auth()!.currentUser?.uid)!) {
            client in
            
            if client != nil {
                self.clientNameLabel.text = client?.name
                self.addressLabel.text = client?.location.fullAddress
                job.clientName = client?.name
                job.location = client?.location ?? Location()
            }

            DatabaseHelper.shared.observeClients(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
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
    
    func updateUser(job: Job, user: User) {
        let assignedTo = "Assigned To: "
        let staffMember = user.name ?? ""
        var status = ""
        
        if job.assignmentStatus == 0 {
            self.assignedToLabel.text = "Assigned To: None"
            return
        }
        else if job.assignmentStatus == 1 && job.jobStatus == JobStatus.UnSchedule.rawValue {
            status = "(Pending)"
        }
        else if job.assignmentStatus == 2 && job.jobStatus == JobStatus.Schedule.rawValue {
            status = "(Accepted)"
        }
        else if job.assignmentStatus == 3 && job.jobStatus == JobStatus.UnSchedule.rawValue {
            status = "(Rejected)"
        }
        
        let wholeStr = "\(assignedTo) \(staffMember) \(status)"
        let attributedString = NSMutableAttributedString(string: wholeStr)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.colorSignin, range: (wholeStr as NSString).range(of: staffMember))
        self.assignedToLabel.attributedText = attributedString
    }
}
