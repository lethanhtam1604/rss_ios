//
//  ClientViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/22/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import DZNEmptyDataSet
import SwiftOverlays
import Firebase

class ClientViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    var constraintsAdded = false
    
    var clients = [Client]()
    var allClients = [Client]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.clipsToBounds = true
        view.addTapToDismiss()

        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        title = "CLIENTS"
        
        let addBarButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addBarButton
        
        searchBar.frame = CGRect(x: 0, y: 0, width: Global.SCREEN_WIDTH, height: 44)
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search"
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.clear
        searchBar.tintColor = Global.colorSignin
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor.clear
                    break
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = Global.colorSeparator
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(ClientTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()

        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        loadData()
    }
    
    func loadData() {
        indicator.startAnimating()
        DatabaseHelper.shared.getClients(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
            clients in
            
            self.indicator.stopAnimating()
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
                
                self.refresh()
            }
            
            DatabaseHelper.shared.observeDeleteClients() {
                newClient in
                
                for index in 0..<self.allClients.count {
                    if self.allClients[index].id == newClient.id {
                        self.allClients.remove(at: index)
                        self.refresh()
                        break
                    }
                }
            }
            
            DatabaseHelper.shared.observeDeleteClient(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
                newClient in
                
                for index in 0..<self.allClients.count {
                    if self.allClients[index].id == newClient.id {
                        self.allClients.remove(at: index)
                        self.refresh()
                        break
                    }
                }
            }
        }
    }
    
    func refresh() {
        search()
    }
    
    func search() {
        let source = allClients
        
        let searchText = searchBar.text ?? ""
        var result = [Client]()
        
        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()
            
            for client in source {
                if (client.name?.lowercased().contains(text)) ?? false || (client.location.fullAddress?.lowercased().contains(text) ?? false) {
                    result.append(client)
                }
//                else {
//                    for contact in client.contacts {
//                        if (contact.jobContact?.lowercased().contains(text)) ?? false || (contact.email?.lowercased().contains(text) ?? false) || (contact.phone?.lowercased().contains(text) ?? false) || (contact.mobile?.lowercased().contains(text) ?? false) {
//                            result.append(client)
//                        }
//                    }
//                }
            }
        }
        
        clients.removeAll()
        clients.append(contentsOf: result)
        
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoAlignAxis(toSuperviewAxis: .vertical)
            tableView.autoMatch(.width, to: .width, of: view)
            tableView.autoPinEdge(.top, to: .bottom, of: searchBar)
            tableView.autoPinEdge(toSuperviewMargin: .bottom)
            
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No client found"
        let attrs = [NSFontAttributeName: UIFont(name: "OpenSans", size: 20),
                     NSForegroundColorAttributeName: Global.colorSignin]
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "DELETE") { action, index in
            SwiftOverlays.showBlockingWaitOverlay()
            DatabaseHelper.shared.deleteClient(userId: (FIRAuth.auth()!.currentUser?.uid)!, client: self.clients[indexPath.row]) {
                SwiftOverlays.removeAllBlockingOverlays()
//                self.allClients.remove(at: indexPath.row)
//                self.clients.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
                if self.clients.count == 0 {
                    tableView.reloadData()
                }
            }
        }
        
        delete.backgroundColor = Global.colorDeleteBtn
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = AddClientViewController()
        viewController.client = clients[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ClientTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.bindingData(client: clients[indexPath.row])
        
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        return cell
    }
    
    func add() {
        let viewController = AddClientViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        search()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

