//
//  StaffFilterViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/1/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class StaffFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var headerView: JobHeaderTableViewCell!
    
    var constraintsAdded = false
    var addJobDelegate: AddJobDelegate!
    
    var jobStatusList = [String]()
    
    var jobStatusIndex = 0
    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! FilterHeaderTableViewCell
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobStatusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let previousCell = tableView.cellForRow(at: NSIndexPath(item: jobStatusIndex, section: 0) as IndexPath) as? FilterTableViewCell {
            previousCell.accessoryType = .none
            previousCell.nameLabel.textColor = UIColor.black
        }

        let currentCell = tableView.cellForRow(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath) as! FilterTableViewCell
        currentCell.accessoryType = .checkmark
        currentCell.nameLabel.textColor = Global.colorSignin
        
        jobStatusIndex = indexPath.row
    }
    
    func apply() {
        UserDefaultManager.getInstance().setJobStatusFilter(value: jobStatusIndex)
        delegate?.applyFilter()
        dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
