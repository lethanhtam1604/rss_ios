
//
//  AssignToViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/28/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import DZNEmptyDataSet
import SwiftOverlays
import Firebase

protocol AssignToDelegate {
    func assignStaff(staff: User)
}

class AssignToViewController: UIViewController , UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var constraintsAdded = false
    var assignToDelegate: AssignToDelegate!
    
    var staffs = [User]()
    var allStaffs = [User]()
    var assign = Assign()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.clipsToBounds = true
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = "ASSIGN TO"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        searchBar.frame = CGRect(x: 0, y: 0, width: Global.SCREEN_WIDTH, height: 44)
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search Staff"
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
        tableView.register(AssignToStaffTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.setNeedsUpdateConstraints()
    
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func loadData() {
        
        indicator.startAnimating()
        DatabaseHelper.shared.getStaffs(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
            staffs in
            
            self.indicator.stopAnimating()
            self.allStaffs = staffs
            
            // observe
            DatabaseHelper.shared.observeUsers() {
                newStaff in
                
                var flag = false
                
                for index in 0..<self.allStaffs.count {
                    if self.allStaffs[index].id == newStaff.id {
                        self.allStaffs[index] = newStaff
                        flag = true
                        break
                    }
                }
                
                if !flag && newStaff.type == 0 && FIRAuth.auth()!.currentUser?.uid == newStaff.adminId {
                    self.allStaffs.append(newStaff)
                }
                
                self.refresh()
            }
            
            DatabaseHelper.shared.observeDeleteUser() {
                newStaff in
                
                for index in 0..<self.allStaffs.count {
                    if self.allStaffs[index].id == newStaff.id {
                        self.allStaffs.remove(at: index)
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

        let source = allStaffs
        
        let searchText = searchBar.text ?? ""
        var result = [User]()
        
        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()
            
            for staff in source {
                if (staff.name?.lowercased().contains(text)) ?? false || (staff.lastName?.lowercased().contains(text) ?? false) || (staff.phone?.lowercased().contains(text) ?? false) || (staff.email?.lowercased().contains(text) ?? false) || (staff.businessName?.lowercased().contains(text) ?? false) || (staff.location.fullAddress?.lowercased().contains(text) ?? false) {
                    result.append(staff)
                }
            }
        }
        
        staffs.removeAll()
        staffs.append(contentsOf: result)
        
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
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No staff found"
        let attrs = [NSFontAttributeName: UIFont(name: "OpenSans", size: 20),
                     NSForegroundColorAttributeName: Global.colorSignin]
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffs.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AssignToStaffTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        if staffs[indexPath.row].id == assign.staffId {
            cell.accessoryType = .checkmark
            cell.nameLabel.textColor = Global.colorSignin
        }
        else {
            cell.accessoryType = .none
            cell.nameLabel.textColor = UIColor.black
        }
        
        cell.bindingData(staff: staffs[indexPath.row])
        
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentCell = tableView.cellForRow(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath) as! AssignToStaffTableViewCell
        currentCell.accessoryType = .checkmark
        currentCell.nameLabel.textColor = Global.colorSignin
        
        if assignToDelegate != nil {
            assignToDelegate.assignStaff(staff: staffs[indexPath.row])
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
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
