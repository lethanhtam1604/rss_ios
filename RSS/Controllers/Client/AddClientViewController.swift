//
//  AddClientViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/1/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import DZNEmptyDataSet
import SwiftOverlays
import Firebase

class AddClientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddContactDelegate, UITextFieldDelegate, LocationDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    var constraintsAdded = false
    
    var clientJobHeader: ClientJobHeaderTableViewCell!
    var jobHeader: JobHeaderTableViewCell!
    
    var clientName = ""
    var clientAddress = ""
    
    var contacts = [Contact]()
    var location = Location()
    
    var clients = [Client]()
    var allClients = [Client]()
    
    var client: Client!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = "ADD CLIENT"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
        saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin,NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
        tableView.register(ClientNameTableViewCell.self, forCellReuseIdentifier: "ClientNameCell")
        tableView.register(ClientJobHeaderTableViewCell.self, forCellReuseIdentifier: "ClientJobHeader")
        tableView.register(JobHeaderTableViewCell.self, forCellReuseIdentifier: "JobHeader")
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
                
                if !flag {
                    self.allClients.append(newClient)
                }
                
                if self.isSearch {
                    self.refresh()
                }
            }
        }
        
        if client != nil {
            searchText = client.name ?? ""
            clientAddress = client.location.fullAddress ?? ""
            contacts = client.contacts
            location = client.location
            title = "EDIT CLIENT"
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
                    location = clients[indexPath.row].location
                }
                else {
                    clientAddress = ""
                }
                
                jobHeader.jobAddressField.text = clientAddress
                
                clientJobHeader.clientNameValueField.text = searchText
                clientJobHeader.clientNameValueField.resignFirstResponder()
                
                clients = [Client]()
                firstInput = true
                tableView.reloadData()
            }
            break
        default:
            let contact = contacts[indexPath.row]
            let viewController = AddContactViewController()
            viewController.addContactDelegate = self
            viewController.contact = contact
            viewController.isCreate = false
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
        
        isSaving = true
        
        if client == nil {
            client = Client()
        }
        
        client.name = clientJobHeader.clientNameValueField.text
        client.location = location
        client.contacts = contacts
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        DatabaseHelper.shared.saveClient(userId: (FIRAuth.auth()!.currentUser?.uid)!, client: client) {_ in 
            SwiftOverlays.removeAllBlockingOverlays()
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
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
