//
//  JobDetailViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/26/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import MapKit

enum JobStatus: Int {
    case UnSchedule = 0
    case InProgress = 1
    case Complete = 2
    case Schedule = 3
}

enum JobAssignmentStatus: Int {
    case New = 0
    case Pending = 1
    case Accepted = 2
    case Rejected = 3
}

class JobDetailViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, AssignJobDelegate, MFMailComposeViewControllerDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var constraintsAdded = false
    
    var jobDetailHeader: JobDetailHeaderTableViewCell!
    var addContactDelegate: AddContactDelegate!
    
    var job = Job()
    var staff: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = "JOB #" + String(job.number!)
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(JobDetailHeaderTableViewCell.self, forCellReuseIdentifier: "header")
        tableView.backgroundColor = UIColor.clear
        tableView.reloadData()
        
        view.setNeedsUpdateConstraints()
        view.addSubview(tableView)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    var loadedHeader = false
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if !loadedHeader {
            loadedHeader = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! JobDetailHeaderTableViewCell
            
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            let checkListAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(checklist))
            cell.checkListAbstractView.addGestureRecognizer(checkListAbstractViewGesture)
            cell.listInfoBtn.addTarget(self, action: #selector(info), for: .touchUpInside)
            cell.startJobBtn.addTarget(self, action: #selector(startJob), for: .touchUpInside)
            
            jobDetailHeader = cell
            
            loadJobDetailHeader()
            
            return cell.contentView
        }
        else {
            return jobDetailHeader.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 + 50 + 100 + 50 + 50 + 10 + 20 + 20 + 2 + 20 + 2 + 20 + 2 + 40 + 10 + 45 + 10 + 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return job.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.bidingData(contact: job.contacts[indexPath.row])
        
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = ContactViewController()
        viewController.contact = job.contacts[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func info() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorSignin
        
        let editJobAction = UIAlertAction(title: "Edit Job", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let viewController = AddJobViewController()
            viewController.job = self.job
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated:true, completion:nil)
        })
        
        let viewMap = UIAlertAction(title: "View Map", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let viewController = MapViewController()
            viewController.latitude = self.job.location.latitude
            viewController.longitude = self.job.location.longitude
            
            self.navigationController?.pushViewController(viewController, animated: true)
        })
        
        let navigateAction = UIAlertAction(title: "Navigate Job", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let latitude: CLLocationDegrees = self.job.location.latitude ?? 0
            let longitude: CLLocationDegrees = self.job.location.longitude ?? 0
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.job.location.fullAddress
            mapItem.openInMaps(launchOptions: options)
            
        })
        
        let assignAction = UIAlertAction(title: "Assign", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let viewController = AssignJobViewController()
            viewController.assignJobDelegate = self
            viewController.assign = self.job.assign
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated:true, completion:nil)
        })
        
        let statusAction = UIAlertAction(title: "Status Job", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if self.job.assignmentStatus == 2 {
                let viewController = AcceptanceViewController()
                viewController.job = self.job
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else {
                let viewController = RejectionViewController()
                viewController.job = self.job
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        })
        
        let reportAction = UIAlertAction(title: "Report", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let viewController = ReportViewController()
            viewController.job = self.job
            self.navigationController?.pushViewController(viewController, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        if UserDefaultManager.getInstance().getUserType() {
            optionMenu.addAction(editJobAction)
            
            if job.jobStatus == JobStatus.InProgress.rawValue {
                optionMenu.addAction(navigateAction)
            }
            optionMenu.addAction(viewMap)
            
            if job.jobStatus == JobStatus.Complete.rawValue {
                optionMenu.addAction(reportAction)
            }
            
            if job.assignmentStatus == JobAssignmentStatus.New.rawValue || job.assignmentStatus == JobAssignmentStatus.Rejected.rawValue {
                optionMenu.addAction(assignAction)
            }
            
            if job.assignmentStatus == JobAssignmentStatus.Accepted.rawValue || job.assignmentStatus == JobAssignmentStatus.Rejected.rawValue {
                if job.accept.seen == false || job.reject.seen == false {
                    statusAction.setValue(UIColor.red, forKey: "titleTextColor")
                }
                
                optionMenu.addAction(statusAction)
            }
            optionMenu.addAction(cancelAction)
        }
        else {
            if job.jobStatus == JobStatus.InProgress.rawValue {
                optionMenu.addAction(navigateAction)
            }
            optionMenu.addAction(viewMap)
            
            if job.jobStatus == JobStatus.Complete.rawValue {
                optionMenu.addAction(reportAction)
            }
            optionMenu.addAction(cancelAction)
        }
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func loadJobDetailHeader() {
        if UserDefaultManager.getInstance().getUserType() {
            jobDetailHeader.jobStatusImgView.image = UIImage(named: "i_job_overdue")
            jobDetailHeader.lineView.backgroundColor = Global.colorU
            jobDetailHeader.startJobBtn.backgroundColor = Global.colorU
            jobDetailHeader.startJobBtn.setTitle("UNSCHEDULE", for: .normal)
            jobDetailHeader.startJobBtn.isUserInteractionEnabled = false
            
            DatabaseHelper.shared.observeJobChange(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
                newJob in
                
                if (newJob.id == self.job.id) {
                    self.job = newJob
                    self.updateJob()
                    self.tableView.reloadData()
                }
            }
        }
        else {
            jobDetailHeader.jobStatusImgView.image = UIImage(named: "i_job_pending")
            jobDetailHeader.lineView.backgroundColor = Global.colorP
            if job.assignmentStatus == 1 {
                jobDetailHeader.startJobBtn.isUserInteractionEnabled = false
            }
            else {
                jobDetailHeader.startJobBtn.isUserInteractionEnabled = true
            }
            
            if job.jobStatus! <= 1 {
                jobDetailHeader.checkListLabel.textColor = Global.colorGray
                jobDetailHeader.checkListAbstractView.isUserInteractionEnabled = false
            }
            
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                if user != nil {
                    // observe
                    DatabaseHelper.shared.observeJobChange(userId: (user?.adminId)!) {
                        newJob in
                        
                        if (newJob.id == self.job.id) {
                            self.job = newJob
                            self.updateJob()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
            if job.recordJob! == 1 || job.recordJob! == 2 {
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = NSTimeZone.default
                dateFormatter.dateStyle = .medium
                dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
                
                let currentDate = dateFormatter.date(from: Utils.getCurrentDate()!)
                
                
                let targetDate = dateFormatter.date(from: job.startTime!)
                
                
                let calendar = NSCalendar.current
                
                let components = calendar.dateComponents([.second], from: targetDate!, to: currentDate!)
                
                self.count = components.second!
                
                if TimerManager.getInstance().timer != nil {
                    TimerManager.getInstance().timer?.invalidate()
                    TimerManager.getInstance().timer = nil
                }
                
                TimerManager.getInstance().timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerStart), userInfo:  nil, repeats: true)
                RunLoop.current.add(TimerManager.getInstance().timer!, forMode: RunLoopMode.commonModes)
            }
        }
        
        DatabaseHelper.shared.getUser(id: job.assign.staffId ?? "") {
            newStaff in
            self.staff = newStaff
            if self.staff != nil {
                self.updateAssign(staff: newStaff!)
            }
        }
        
        DatabaseHelper.shared.observeUsers() {
            newStaff in
            
            if (newStaff.id == self.job.assign.staffId) {
                self.staff = newStaff
                self.updateAssign(staff: newStaff)
            }
        }
        
        self.updateJob()
    }
    
    var mytimer: Timer!
    
    func updateJob() {
        if UserDefaultManager.getInstance().getUserType() {
            DatabaseHelper.shared.getClient(clientId: job.clientId!, userId: (FIRAuth.auth()!.currentUser?.uid)!) {
                client in
                
                if client != nil {
                    self.jobDetailHeader.clientNameLabel.text = client?.name
                    self.jobDetailHeader.addressLabel.text = client?.location.fullAddress
                }
                
                DatabaseHelper.shared.observeClients(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
                    newClient in
                    if newClient.id == self.job.clientId! {
                        self.jobDetailHeader.clientNameLabel.text = newClient.name
                        self.jobDetailHeader.addressLabel.text = newClient.location.fullAddress
                    }
                }
            }
            
        }
        else {
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                if user != nil {
                    DatabaseHelper.shared.getClient(clientId: self.job.clientId!, userId: (user?.adminId)!) {
                        client in
                        
                        if client != nil {
                            self.jobDetailHeader.clientNameLabel.text = client?.name
                            self.jobDetailHeader.addressLabel.text = client?.location.fullAddress
                        }
                        
                        DatabaseHelper.shared.observeClients(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
                            newClient in
                            if newClient.id == self.job.clientId! {
                                self.jobDetailHeader.clientNameLabel.text = newClient.name
                                self.jobDetailHeader.addressLabel.text = newClient.location.fullAddress
                            }
                        }
                    }
                    
                }
            }
        }
        
        jobDetailHeader.jobDescriptionValueTV.text = job.jobDescription
        jobDetailHeader.contactNameLabel.text = job.contacts[0].jobContact
        
        if job.jobStatus == JobStatus.UnSchedule.rawValue {
            jobDetailHeader.jobStatusImgView.image = UIImage(named: "i_job_overdue")
            jobDetailHeader.lineView.backgroundColor = Global.colorU
        }
        else if job.jobStatus == JobStatus.Schedule.rawValue {
            jobDetailHeader.jobStatusImgView.image = UIImage(named: "i_job_schedule")
            jobDetailHeader.lineView.backgroundColor = Global.colorS
        }
        else if job.jobStatus == JobStatus.InProgress.rawValue {
            jobDetailHeader.jobStatusImgView.image = UIImage(named: "i_job_pending")
            jobDetailHeader.lineView.backgroundColor = Global.colorP
        }
        else {
            jobDetailHeader.jobStatusImgView.image = UIImage(named: "i_job_complete")
            jobDetailHeader.lineView.backgroundColor = Global.colorC
        }
        
        if job.recordJob! >= 2 {
            jobDetailHeader.checkListLabel.textColor = UIColor.black
            jobDetailHeader.checkListAbstractView.isUserInteractionEnabled = true
        }
        else {
            jobDetailHeader.checkListLabel.textColor = Global.colorGray
            jobDetailHeader.checkListAbstractView.isUserInteractionEnabled = false
        }
        
        if UserDefaultManager.getInstance().getUserType() || job.assignmentStatus == 1 {
            if job.jobStatus == JobStatus.UnSchedule.rawValue {
                jobDetailHeader.startJobBtn.backgroundColor = Global.colorU
                jobDetailHeader.startJobBtn.setTitle("UNSCHEDULE", for: .normal)
            }
            else if job.jobStatus == JobStatus.Schedule.rawValue {
                jobDetailHeader.startJobBtn.backgroundColor = Global.colorS
                jobDetailHeader.startJobBtn.setTitle("SCHEDULE", for: .normal)
            }
            else if job.jobStatus == JobStatus.InProgress.rawValue {
                jobDetailHeader.startJobBtn.backgroundColor = Global.colorP
                jobDetailHeader.startJobBtn.setTitle("INPROGRESS", for: .normal)
            }
            else {
                jobDetailHeader.startJobBtn.backgroundColor = Global.colorC
                jobDetailHeader.startJobBtn.setTitle("COMPLETED", for: .normal)
            }
            
            if job.accept.seen == false || job.reject.seen == false {
                jobDetailHeader.circleRed.isHidden = false
            }
            else {
                jobDetailHeader.circleRed.isHidden = true
            }
        }
        else {
            if job.recordJob == 0 {
                jobDetailHeader.startJobBtn.backgroundColor = Global.colorC
                jobDetailHeader.startJobBtn.setTitle("START", for: .normal)
            }
            else if job.recordJob == 1 {
                jobDetailHeader.startJobBtn.setTitle(String(format:"%02i:%02i:%02i", Int(job.arrivedTime!) / 3600, Int(job.arrivedTime!) / 60 % 60, Int(job.arrivedTime!) % 60) + "\nArrived at job", for: .normal)
                jobDetailHeader.startJobBtn.backgroundColor = Global.colorArrivedJob
            }
            else if job.recordJob == 2 {
                jobDetailHeader.startJobBtn.setTitle(String(format:"%02i:%02i:%02i", Int(job.checkoutTime!) / 3600, Int(job.checkoutTime!) / 60 % 60, Int(job.checkoutTime!) % 60) + "\nCheck Out", for: .normal)
                jobDetailHeader.startJobBtn.backgroundColor = Global.colorCheckoutJob
            }
            else {
                jobDetailHeader.startJobBtn.setTitle(String(format:"ARRIVED - %02i:%02i:%02i", Int(job.checkoutTime!) / 3600, Int(job.checkoutTime!) / 60 % 60, Int(job.checkoutTime!) % 60), for: .normal)
                jobDetailHeader.startJobBtn.backgroundColor = Global.colorStartJob
            }
        }
    }
    
    func saveAssignJob(assign: Assign) {
        job.assign = assign
        job.jobStatus = JobStatus.UnSchedule.rawValue
        job.assignmentStatus = JobAssignmentStatus.Pending.rawValue
        job.invitationSeen = false
        
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            
            let message = Message()
            message.title = (user?.name)! + " assigned you the job #" + String(self.job.number!)
            message.body = " - ACCEPTANCE DATE: " + assign.acceptanceDate!
            
            DatabaseHelper.shared.sendMessage(userId: (assign.staffId)!, message: message) {
                _ in
                
            }
        }
        
        DatabaseHelper.shared.getUser(id: job.assign.staffId ?? "") {
            newStaff in
            self.staff = newStaff
            if self.staff != nil {
                self.updateAssign(staff: newStaff!)
                
                let badge = (self.staff?.totalBadge)! + 1
                self.staff?.totalBadge = badge
                
                DatabaseHelper.shared.saveUser(user: self.staff!) {
                    
                }
            }
        }
        
        DatabaseHelper.shared.saveJob(userId: (FIRAuth.auth()!.currentUser?.uid)!, job: job) {_ in 
            
        }
    }
    
    func updateAssign(staff: User) {
        
        let assignedTo = "Assigned To: "
        let staffMember = staff.name ?? ""
        var status = ""
        
        if job.assignmentStatus == 0 {
            jobDetailHeader.assignedToLabel.text = "Assigned To: None"
            return
        }
        else if job.assignmentStatus == 1 {
            status = "(Pending)"
        }
        else if job.assignmentStatus == 2 {
            status = "(Accepted)"
        }
        else if job.assignmentStatus == 3 {
            status = "(Rejected)"
        }
        
        let wholeStr = "\(assignedTo) \(staffMember) \(status)"
        let attributedString = NSMutableAttributedString(string: wholeStr)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.colorSignin, range: (wholeStr as NSString).range(of: staffMember))
        jobDetailHeader.assignedToLabel.attributedText = attributedString
    }
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var isRunning = false
    
    func startJob() {
        if job.recordJob == 0 {
            TimerManager.getInstance().timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerStart), userInfo: nil, repeats: true)
            RunLoop.current.add(TimerManager.getInstance().timer!, forMode: RunLoopMode.commonModes)
            
            //            Utils.showAlertMessageAction(title: "RSS", message: "Do you want to notify client with message?", viewController: self, alertDelegate: self)
            notifyClient()
            
            job.startTime = Utils.getCurrentDate()
            job.jobStatus = JobStatus.InProgress.rawValue
            job.recordJob = 1
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                DatabaseHelper.shared.saveJob(userId: (user?.adminId)!, job: self.job) {_ in }
            }
        }
            
        else if job.recordJob! == 1 {
            self.job.arrivedTime = self.count
            job.recordJob = 2
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                DatabaseHelper.shared.saveJob(userId: (user?.adminId)!, job: self.job) {_ in }
            }
        }
        else {
            
            if job.checkList.narrativeOfRepairs == nil || job.checkList.narrativeOfRepairs == "" {
                Utils.showAlert(title: "Error", message: "Narrative repairs can not be empty in Check list", viewController: self)
                return
            }
            
            if job.checkList.signature == nil || job.checkList.signature == "" {
                Utils.showAlert(title: "Error", message: "Signature can not be empty in Check list", viewController: self)
                return
            }
            
            if self.job.jobStatus != JobStatus.Complete.rawValue {
                showOptionCheckout()
            }
            else {
                let viewController = ExpensesViewController()
                viewController.job = self.job
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func showOptionCheckout() {
        let optionMenu = UIAlertController(title: "Checkout", message: "is there any other expense you paid during this Job?", preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorSignin
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let viewController = ExpensesViewController()
            viewController.job = self.job
            self.navigationController?.pushViewController(viewController, animated: true)
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                if user != nil {
                    self.job.jobStatus = JobStatus.Complete.rawValue
                    self.job.recordJob = 3
                    
                    DatabaseHelper.shared.saveJob(userId: (user?.adminId)!, job: self.job) {_ in

                    }
                    
                    let message = Message()
                    message.title = (user?.name)! + " completed the job #" + String(self.job.number!)
                    message.body = "COMPLETE DATE: " + Utils.getCurrentDate()!
                    
                    DatabaseHelper.shared.sendMessage(userId: (user?.adminId)!, message: message) {
                        _ in
                        
                    }
                }
                else {
                    Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
                }
            }

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(yesAction)
        optionMenu.addAction(noAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func notifyClient() {
        let optionMenu = UIAlertController(title: "Start Job", message: "Do you want to notify client with message?", preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorSignin
        
        let viaMessageAction = UIAlertAction(title: "Via Message", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.viaMessage()
        })
        
        let viaEmailAction = UIAlertAction(title: "Via Email", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.viaEmail()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        optionMenu.addAction(viaMessageAction)
        optionMenu.addAction(viaEmailAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func viaMessage() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            if self.job.contacts.count > 0 {
                if let mobile = self.job.contacts[0].mobile {
                    if mobile != "" {
                        controller.recipients = [mobile]
                    }
                    else {
                        controller.recipients = [self.job.contacts[0].phone!]
                    }
                }
                else {
                    controller.recipients = [self.job.contacts[0].phone!]
                }
            }
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func viaEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            if self.job.contacts.count > 0 {
                if let mobile = self.job.contacts[0].mobile {
                    if mobile != "" {
                        mail.setMessageBody(mobile, isHTML: false)
                    }
                    else {
                        mail.setMessageBody(self.job.contacts[0].phone!, isHTML: false)
                    }
                }
                else {
                    mail.setMessageBody(self.job.contacts[0].phone!, isHTML: false)
                }
                
                mail.setToRecipients([self.job.contacts[0].email!])
                mail.setSubject("")
            }
            mail.navigationBar.tintColor = Global.colorMain
            present(mail, animated: true, completion: nil)
        }
        else {
            Utils.showAlert(title: "Error", message: "You are not logged in email. Please check email configuration and try again", viewController: self)
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    var count = 0
    
    func timerStart() {
        self.count += 1
        let hours = Int(self.count) / 3600
        let minutes = Int(self.count) / 60 % 60
        let seconds = Int(self.count) % 60
        
        if self.job.recordJob! == 1 {
            self.jobDetailHeader.startJobBtn.setTitle(String(format:"%02i:%02i:%02i", hours, minutes, seconds) + "\nArrived at job", for: .normal)
            self.jobDetailHeader.startJobBtn.backgroundColor = Global.colorArrivedJob
        }
        else if self.job.recordJob! == 2 {
            self.jobDetailHeader.startJobBtn.setTitle(String(format:"%02i:%02i:%02i", hours, minutes, seconds) + "\nCheck Out", for: .normal)
            self.jobDetailHeader.startJobBtn.backgroundColor = Global.colorCheckoutJob
        }
        else if self.job.recordJob! == 3  {
            if TimerManager.getInstance().timer != nil {
                TimerManager.getInstance().timer?.invalidate()
                TimerManager.getInstance().timer = nil
            }
            self.job.checkoutTime = self.count
            self.job.jobStatus = JobStatus.Complete.rawValue
            
            DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                user in
                DatabaseHelper.shared.saveJob(userId: (user?.adminId)!, job: self.job) {_ in }
            }
        }
    }
    
    func checklist() {
        let viewController = CheckListViewController()
        viewController.job = job
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func cancel() {
        if TimerManager.getInstance().timer != nil {
            TimerManager.getInstance().timer?.invalidate()
            TimerManager.getInstance().timer = nil
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
