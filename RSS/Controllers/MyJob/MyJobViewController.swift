//
//  MyJobViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/22/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import DZNEmptyDataSet
import Firebase

class MyJobViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, FilterDelegate {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var constraintsAdded = false
    
    var allJobs = [Job]()
    var jobs = [Job]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = UIColor.white
        view.clipsToBounds = true
        view.addTapToDismiss()
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        title = "MY JOBS"
        
        let filterBarButton = UIBarButtonItem(image: UIImage(named: "filter"), style: .done, target: self, action: #selector(filter))
        self.navigationItem.leftBarButtonItem = filterBarButton
        
        searchBar.frame = CGRect(x: 0, y: 0, width: Global.SCREEN_WIDTH, height: 44)
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search"
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.clear
        searchBar.tintColor = Global.colorSignin
        searchBar.endEditing(true)
        
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
        tableView.register(MyJobTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        loadData()
        
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
        
    }
    
    func loadData() {
        indicator.startAnimating()
        
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            
            if user != nil {
                
                DatabaseHelper.shared.getJobsByStaff(userId: (user?.adminId)!, staffId: (FIRAuth.auth()!.currentUser?.uid)!) {
                    jobs in
                    
                    self.indicator.stopAnimating()
                    self.allJobs = jobs
                    
                    self.refresh()
                    
                    // observe
                    DatabaseHelper.shared.observeJobs(userId: (user?.adminId)!) {
                        newJob in
                        
                        var flag = false
                        
                        for index in 0..<self.allJobs.count {
                            if self.allJobs[index].id == newJob.id {
                                self.allJobs[index] = newJob
                                flag = true
                                break
                            }
                        }
                        
                        if !flag && newJob.assign.staffId == (FIRAuth.auth()!.currentUser?.uid)! {
                            self.allJobs.append(newJob)
                        }
                        
                        self.refresh()
                    }
                }
            }
            else {
                self.indicator.stopAnimating()
            }
        }
    }
    
    func refresh() {
        search()
    }
    
    func search() {
        
        let source = allJobs
        
        let searchText = searchBar.text ?? ""
        var result = [Job]()
        
        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()
            
            for job in source {
                if (job.clientName?.lowercased().contains(text)) ?? false || (job.location.fullAddress?.lowercased().contains(text) ?? false) || (job.jobDescription?.lowercased().contains(text) ?? false) {
                    result.append(job)
                }
            }
        }
        
        jobs.removeAll()
        
        for job in result {
            let jobStatusIndex = UserDefaultManager.getInstance().getJobStatusFilter()
            
            if (jobStatusIndex == 0 && job.assignmentStatus == JobAssignmentStatus.Accepted.rawValue) {
                jobs.append(job)
            }
            else if (jobStatusIndex == 1 && job.assignmentStatus == JobAssignmentStatus.Accepted.rawValue && job.jobStatus == JobStatus.Complete.rawValue) {
                jobs.append(job)
            }
            else if (jobStatusIndex == 2 && job.assignmentStatus == JobAssignmentStatus.Accepted.rawValue && job.jobStatus == JobStatus.InProgress.rawValue) {
                jobs.append(job)
            }
            else if (jobStatusIndex == 3 && job.assignmentStatus == JobAssignmentStatus.Accepted.rawValue && job.jobStatus == JobStatus.Schedule.rawValue) {
                jobs.append(job)
            }
        }
        
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
    
    func filter() {
        let viewController = StaffFilterViewController()
        viewController.delegate = self
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func applyFilter() {
        refresh()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No my jobs found"
        let attrs = [NSFontAttributeName: UIFont(name: "OpenSans", size: 20),
                     NSForegroundColorAttributeName: Global.colorSignin]
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyJobTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none
        
        cell.bidingData(job: jobs[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = JobDetailViewController()
        viewController.job = jobs[indexPath.row]
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

