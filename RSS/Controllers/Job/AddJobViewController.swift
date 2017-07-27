//
//  AddJobViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/23/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import DZNEmptyDataSet
import SwiftOverlays
import Firebase

protocol AddJobDelegate {
    func saveJob()
}

class AddJobViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddContactDelegate, UITextFieldDelegate, LocationDelegate, AssignJobDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    var constraintsAdded = false
    
    var clientJobHeader: ClientJobHeaderTableViewCell!
    var jobHeader: JobHeaderTableViewCell!
    var jobFooter: JobFooterTableViewCell!

    var clientName = ""
    var clientAddress = ""
    var jobDescription = ""

    var contacts = [Contact]()
    var location = Location()
    
    var clients = [Client]()
    var allClients = [Client]()
    var currentClient: Client?
    
    var job: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = Global.colorSignin
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        title = "ADD JOBS"
        
        let cancelBarButton = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(cancel))
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
        saveBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
        tableView.register(ClientNameTableViewCell.self, forCellReuseIdentifier: "ClientNameCell")
        tableView.register(ClientJobHeaderTableViewCell.self, forCellReuseIdentifier: "ClientJobHeader")
        tableView.register(JobHeaderTableViewCell.self, forCellReuseIdentifier: "JobHeader")
        tableView.register(JobFooterTableViewCell.self, forCellReuseIdentifier: "footer")
        tableView.backgroundColor = UIColor.clear
        
        view.addSubview(tableView)
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    var isSearch = false
    
    func loadData() {
        DatabaseHelper.shared.getClients(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
            clients in
            
            self.allClients = clients
            
            // observe
            DatabaseHelper.shared.observeClients(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
                newClient in
                
                var flag = false
                for index in 0..<self.allClients.count {
                    if self.allClients[index].id == newClient.id {
                        self.allClients[index] = newClient
                        flag = true
                        break
                    }
                }
                
                if self.job != nil {
                    for index in 0..<self.allClients.count {
                        if self.allClients[index].id == self.job.clientId {
                            self.currentClient = self.allClients[index]
                            self.updateJob()
                            self.tableView.reloadData()
                            break
                        }
                    }
                }
                
                
                if !flag {
                    self.allClients.append(newClient)
                }
                
                if self.isSearch {
                    self.refresh()
                }
            }
        }
        
    }
    
    func updateJob() {
        if let client = self.currentClient {
            title = "EDIT JOBS"
            searchText = client.name ?? ""
            clientAddress = client.location.fullAddress ?? ""
            contacts = client.contacts
            location = client.location
            jobDescription = job.jobDescription ?? ""
        }
    }
    
    func refresh() {
        search()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClientJobHeader") as! ClientJobHeaderTableViewCell
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            clientJobHeader = cell
            
            cell.clientNameValueField.text = searchText
            cell.clientNameValueField.delegate = self
            
            return cell.contentView
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobHeader") as! JobHeaderTableViewCell
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            jobHeader = cell
            
            cell.jobAddressField.text = clientAddress
            cell.addBtn.addTarget(self, action: #selector(addContact), for: .touchUpInside)
            cell.jobAddressBtn.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
            
            return cell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 100
        default:
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        default:
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "footer") as! JobFooterTableViewCell
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            jobFooter = cell
            
            cell.jobDescriptionValueTV.text = jobDescription
            
            return cell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        switch indexPath.section {
        case 0:
            return nil
        default:
            let delete = UITableViewRowAction(style: .normal, title: "DELETE") { action, index in
                self.contacts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            delete.backgroundColor = Global.colorDeleteBtn
            
            return [delete]
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50
        default:
            return 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if clients.count > 1 {
                return clients.count
            }
            else {
                return 0
            }
        default:
            return contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClientNameCell") as! ClientNameTableViewCell
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            
            cell.bidingData(index: indexPath.row, client: clients[indexPath.row], count: clients.count)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactTableViewCell
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            
            cell.bidingData(contact: contacts[indexPath.row])
            
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row >= 1 {
                if indexPath.row < clients.count - 1 {
                    clientAddress = clients[indexPath.row].location.fullAddress ?? ""
                    searchText = clients[indexPath.row].name ?? ""
                    contacts = clients[indexPath.row].contacts
                    location = clients[indexPath.row].location
                    currentClient = clients[indexPath.row]
                }
                else {
                    clientAddress = ""
                    contacts = [Contact]()
                    location = Location()
                    currentClient = nil
                }
                
                jobDescription = jobFooter.jobDescriptionValueTV.text
                jobHeader.jobAddressField.text = clientAddress
                
                clientJobHeader.clientNameValueField.text = searchText
                clientJobHeader.clientNameValueField.resignFirstResponder()
                
                clients = [Client]()
                firstInput = true
                tableView.reloadData()
            }
            break
        default:
            let viewController = AddContactViewController()
            viewController.addContactDelegate = self
            viewController.isCreate = false
            viewController.contact = contacts[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        }
        
    }
    
    func addLocation() {
        let viewController = LocationViewController()
        viewController.locationDelegate = self
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func addContact() {
        let viewController = AddContactViewController()
        viewController.addContactDelegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    var isSaving = false
    
    func save() {
        if isSaving {
            return
        }
        
        if clients.count > 0 {
            Utils.showAlert(title: "Error", message: "Choose clients name please!", viewController: self)
            return
        }
        
        if clientJobHeader.clientNameValueField.text == "" {
            Utils.showAlert(title: "Error", message: "Cient name can not be empty!", viewController: self)
            return
        }
        
        if jobHeader.jobAddressField.text == "" {
            Utils.showAlert(title: "Error", message: "Job address can not be empty!", viewController: self)
            return
        }
        
        if contacts.count == 0 {
            Utils.showAlert(title: "Error", message: "Contact details can not be empty!", viewController: self)
            return
        }
        
        if jobFooter.jobDescriptionValueTV.text == "" {
            Utils.showAlert(title: "Error", message: "Job description can not be empty!", viewController: self)
            return
        }
        
        isSaving = true
        
        if job == nil {
            job = Job()
        }
        
        job.clientName = clientJobHeader.clientNameValueField.text
        job.location = location
        job.contacts = contacts
        job.jobDescription = jobFooter.jobDescriptionValueTV.text
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        DatabaseHelper.shared.getIdMax(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
            idMax in
            if self.job.number == nil {
                self.job.number = idMax
            }
            
            if self.currentClient == nil {
                self.isSearch = false
                
                self.currentClient = Client()
                self.currentClient?.name = self.clientJobHeader.clientNameValueField.text
                self.currentClient?.location = self.location
                self.currentClient?.contacts = self.contacts
                
                DatabaseHelper.shared.saveClient(userId: (FIRAuth.auth()!.currentUser?.uid)!, client: self.currentClient!) {
                    clientId in
                    self.currentClient?.id = clientId
                    self.job.clientId = clientId
                    DatabaseHelper.shared.saveJob(userId: (FIRAuth.auth()!.currentUser?.uid)!, job: self.job) {
                        jobId in
                        self.job.id = jobId
                        SwiftOverlays.removeAllBlockingOverlays()
                        self.isSaving = true
                        
                        if self.job.assignmentStatus == nil || self.job.assignmentStatus == 0 {
                            self.notifyAssignJobToStaff()
                        }
                        else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            else {
                self.job.clientId = self.currentClient?.id
                
                DatabaseHelper.shared.saveJob(userId: (FIRAuth.auth()!.currentUser?.uid)!, job: self.job) {
                    jobId in
                    self.job.id = jobId
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.isSaving = true
                    
                    if self.job.assignmentStatus == nil || self.job.assignmentStatus == 0 {
                        self.notifyAssignJobToStaff()
                    }
                    else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func notifyAssignJobToStaff() {
        let optionMenu = UIAlertController(title: "Assign Job", message: "Do you want to assign this job to any staff?", preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorSignin
        
        let assignAction = UIAlertAction(title: "Assign", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let viewController = AssignJobViewController()
            viewController.assignJobDelegate = self
            viewController.assign = self.job.assign
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated:true, completion:nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        
        optionMenu.addAction(assignAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
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
            if let staff = newStaff {
                
                let badge = (staff.totalBadge)! + 1
                staff.totalBadge = badge
                
                DatabaseHelper.shared.saveUser(user: staff) {
                    
                }
            }
        }
        
        DatabaseHelper.shared.saveJob(userId: (FIRAuth.auth()!.currentUser?.uid)!, job: job) { _ in
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func saveContact(contact: Contact, isCreate: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if isCreate {
                self.contacts.append(contact)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.contacts.count - 1, section: 1)], with: .automatic)
                self.tableView.endUpdates()
                let indexPath = NSIndexPath(row: self.contacts.count - 1, section: 1)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
            else {
                self.tableView.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        default:
            textField.resignFirstResponder()
            return true
        }
    }
    
    func saveLocation(location: Location) {
        self.location = location
        clientAddress = location.fullAddress!
        jobHeader.jobAddressField.text = location.fullAddress
    }
    
    var timer = Timer()
    var searchText = ""
    var firstInput = true
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        isSearch = true
        if timer.isValid {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(search), userInfo: nil, repeats: false)
        return true
    }
    
    func search() {
        if searchText == "" {
            clients = [Client]()
            tableView.reloadData()
            firstInput = true
        }
        else {
            self.tableView.beginUpdates()
            var oldChanged = [NSIndexPath]()
            if !firstInput {
                for i in 1..<self.clients.count {
                    let indexPath = NSIndexPath(item: i, section: 0)
                    oldChanged.append(indexPath)
                }
            }
            self.tableView.deleteRows(at: oldChanged as [IndexPath], with: .bottom)
            
            clients = [Client]()
            
            let matching = Client()
            matching.name = "MATCHING CLIENTS"
            clients.append(matching)
            
            let text = searchText.lowercased()
            for client in allClients {
                if client.name?.lowercased().contains(text) ?? false {
                    clients.append(client)
                }
            }
            
            let newClient = Client()
            newClient.name = searchText
            newClient.location.fullAddress = "Vietnam"
            clients.append(newClient)
            
            var newChanged = [NSIndexPath]()
            
            if firstInput {
                for i in 0..<self.clients.count {
                    let indexPath = NSIndexPath(item: i, section: 0)
                    newChanged.append(indexPath)
                }
                firstInput = false
            }
            else {
                for i in 1..<self.clients.count {
                    let indexPath = NSIndexPath(item: i, section: 0)
                    newChanged.append(indexPath)
                }
            }
            
            self.tableView.insertRows(at: newChanged as [IndexPath], with: .top)
            self.tableView.endUpdates()
        }
    }
}
