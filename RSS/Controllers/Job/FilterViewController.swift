//
//  FilterViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/24/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    func applyFilter()
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var headerView: JobHeaderTableViewCell!
    
    var constraintsAdded = false
    var addJobDelegate: AddJobDelegate!
    
    var jobStatusList = [String]()
    var assignmentStatusList = [String]()
    
    var jobStatusIndex = 0
    var assignmentStatusIndex = 0
    
    open weak var delegate: FilterDelegate?
    
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
        
        title = "FILTER"
        
        let cancelBarButton = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(cancel))
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        let applyBarButton = UIBarButtonItem(title: "APPLY", style: .done, target: self, action: #selector(apply))
        applyBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = applyBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(FilterHeaderTableViewCell.self, forCellReuseIdentifier: "header")
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        jobStatusIndex = UserDefaultManager.getInstance().getJobStatusFilter()
        assignmentStatusIndex = UserDefaultManager.getInstance().getAssignmentStatusFilter()
        
        loadData()
        
        view.addSubview(tableView)
        view.setNeedsUpdateConstraints()
    }
    
    func loadData() {
        jobStatusList.append("All Jobs")
        jobStatusList.append("Completed Jobs")
        jobStatusList.append("In Progress Jobs")
        jobStatusList.append("Schedule Jobs")
        jobStatusList.append("Un Schedule Jobs")
        
        assignmentStatusList.append("All")
        assignmentStatusList.append("New")
        assignmentStatusList.append("Pending")
        assignmentStatusList.append("Accepted")
        assignmentStatusList.append("Rejected")
        
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! FilterHeaderTableViewCell
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        switch section {
        case 0:
            cell.nameLabel.text = "JOBS"
            break
        default:
            cell.nameLabel.text = "STATUS"
            break

        }
        return cell.contentView

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return jobStatusList.count
        default:
            return assignmentStatusList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FilterTableViewCell
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            
            if indexPath.row == jobStatusIndex {
                cell.accessoryType = .checkmark
                cell.nameLabel.textColor = Global.colorSignin
            }
            else {
                cell.accessoryType = .none
                cell.nameLabel.textColor = UIColor.black
            }
            
            cell.bidingData(text: jobStatusList[indexPath.row])
            
            if indexPath.row == jobStatusList.count - 1 {
                cell.borderView.isHidden = true
            }
            else {
                cell.borderView.isHidden = false
            }
            
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FilterTableViewCell
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            
            if indexPath.row == assignmentStatusIndex {
                cell.accessoryType = .checkmark
                cell.nameLabel.textColor = Global.colorSignin
            }
            else {
                cell.accessoryType = .none
                cell.nameLabel.textColor = UIColor.black
            }
            
            cell.bidingData(text: assignmentStatusList[indexPath.row])
            
            if indexPath.row == assignmentStatusList.count - 1 {
                cell.borderView.isHidden = true
                
            }
            else {
                cell.borderView.isHidden = false
            }
            
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if let previousCell = tableView.cellForRow(at: NSIndexPath(item: jobStatusIndex, section: 0) as IndexPath) as? FilterTableViewCell {
                previousCell.accessoryType = .none
                previousCell.nameLabel.textColor = UIColor.black
            }
            
            let currentCell = tableView.cellForRow(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath) as! FilterTableViewCell
            currentCell.accessoryType = .checkmark
            currentCell.nameLabel.textColor = Global.colorSignin
            
            jobStatusIndex = indexPath.row
            break
        default:
            if let previousCell = tableView.cellForRow(at: NSIndexPath(item: assignmentStatusIndex, section: 1) as IndexPath) as? FilterTableViewCell {
                previousCell.accessoryType = .none
                previousCell.nameLabel.textColor = UIColor.black
            }

            let currentCell = tableView.cellForRow(at: NSIndexPath(item: indexPath.row, section: 1) as IndexPath) as! FilterTableViewCell
            currentCell.accessoryType = .checkmark
            currentCell.nameLabel.textColor = Global.colorSignin
            
            assignmentStatusIndex = indexPath.row
            break
        }
    }
    
    func apply() {
        UserDefaultManager.getInstance().setJobStatusFilter(value: jobStatusIndex)
        UserDefaultManager.getInstance().setAssignmentStatusFilter(value: assignmentStatusIndex)
        delegate?.applyFilter()
        dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
