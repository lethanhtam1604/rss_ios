//
//  StaffViewController.swift
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

class StaffViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var constraintsAdded = false
    
    var staffs = [User]()
    var allStaffs = [User]()
    
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
        title = "STAFF"
        
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
        tableView.register(StaffTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(indicator)
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
                
                if !flag && newStaff.type == 0 && newStaff.adminId == FIRAuth.auth()!.currentUser?.uid {
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
            
            indicator.autoPinEdgesToSuperviewEdges()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "DELETE") { action, index in
            SwiftOverlays.showBlockingWaitOverlay()
            
            let staffId = self.staffs[indexPath.row].id
            
            DatabaseHelper.shared.deleteUser(userId: staffId) {
                
                DatabaseHelper.shared.getJobsByStaff(userId: (FIRAuth.auth()!.currentUser?.uid)!, staffId: staffId) {
                    jobs in
                    
                    for job in jobs {
                        job.assign = Assign()
                        job.jobStatus = JobStatus.UnSchedule.rawValue
                        job.assignmentStatus = 0
                        
                        DatabaseHelper.shared.saveJob(userId: (FIRAuth.auth()!.currentUser?.uid)!, job: job) {_ in 
                            
                        }
                    }
                }
                
                if self.staffs.count == 0 {
                    tableView.reloadData()
                }
                SwiftOverlays.removeAllBlockingOverlays()
            }
        }
        delete.backgroundColor = Global.colorDeleteBtn
        
        let edit = UITableViewRowAction(style: .normal, title: "EDIT") { action, index in
            let viewController = AddStaffViewController()
            viewController.staff = self.staffs[indexPath.row]
            viewController.isEdit = true
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated:true, completion:nil)
        }
        edit.backgroundColor = Global.colorEditBtn
        
        return [edit, delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = StaffDetailViewController()
        viewController.staff = staffs[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StaffTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.bindingData(staff: staffs[indexPath.row])
        
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        return cell
    }
    
    func add() {
        let viewController = AddStaffViewController()
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated:true, completion:nil)
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
