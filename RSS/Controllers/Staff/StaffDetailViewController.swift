//
//  StaffDetailViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/31/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftOverlays
import Firebase

class StaffDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    let tableView = UITableView(frame: .zero, style: .grouped)
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    var constraintsAdded = false
    
    var unScheduleJobs = [Job]()
    var inprogressJobs = [Job]()
    var completedJobs = [Job]()
    var jobs = [Job]()
    
    var allJobs = [Job]()
    var staff = User()
    
    var numberOfJobStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = staff.name
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let filterBarButton = UIBarButtonItem(image: UIImage(named: "filter"), style: .done, target: self, action: #selector(filter))
        filterBarButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = filterBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.separatorColor = Global.colorSeparator
        tableView.register(StaffJobTableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.register(StaffHeaderTableViewCell.self, forCellReuseIdentifier: "header")
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        
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
        DatabaseHelper.shared.getJobsByStaff(userId: (FIRAuth.auth()!.currentUser?.uid)!, staffId: staff.id) {
            jobs in
            
            self.indicator.stopAnimating()
            self.allJobs = jobs
            
            // observe
            DatabaseHelper.shared.observeJobs(userId: (FIRAuth.auth()!.currentUser?.uid)!) {
                newJob in
                
                var flag = false
                
                for index in 0..<self.allJobs.count {
                    if self.allJobs[index].id == newJob.id {
                        self.allJobs[index] = newJob
                        flag = true
                        break
                    }
                }
                
                if !flag && newJob.assign.staffId == self.staff.id {
                    self.allJobs.append(newJob)
                }
                
                self.refresh()
            }
        }
    }
    
    func refresh() {
        search()
    }
    
    func search() {
        jobs.removeAll()
        
        for job in allJobs {
            let jobStatusIndex = UserDefaultManager.getInstance().getJobStatusFilter()
            let assignmentStatusIndex = UserDefaultManager.getInstance().getAssignmentStatusFilter()
            
            if jobStatusIndex == 0 && assignmentStatusIndex == 0 {
                jobs.append(job)
            }
            else if jobStatusIndex == 1 && job.jobStatus == JobStatus.Complete.rawValue && (assignmentStatusIndex == 0 || assignmentStatusIndex == 3) {
                jobs.append(job)
            }
            else if jobStatusIndex == 2 && job.jobStatus == JobStatus.InProgress.rawValue && (assignmentStatusIndex == 0 || assignmentStatusIndex == 3)  {
                jobs.append(job)
            }
            else if jobStatusIndex == 3 && job.jobStatus == JobStatus.Schedule.rawValue && (assignmentStatusIndex == 0 || assignmentStatusIndex == 3) {
                jobs.append(job)
            }
            else if jobStatusIndex == 4 && job.jobStatus == JobStatus.UnSchedule.rawValue {
                if assignmentStatusIndex == 0 {
                    jobs.append(job)
                }
                else if assignmentStatusIndex == 1 && job.assignmentStatus == JobAssignmentStatus.New.rawValue {
                    jobs.append(job)
                }
                else if assignmentStatusIndex == 2 && job.assignmentStatus == JobAssignmentStatus.Pending.rawValue {
                    jobs.append(job)
                }
                else if assignmentStatusIndex == 4 && job.assignmentStatus == JobAssignmentStatus.Rejected.rawValue {
                    jobs.append(job)
                }
            }
        }
        
        if unScheduleJobs.count > 0 {
            numberOfJobStatus += 1
        }
        
        if inprogressJobs.count > 0 {
            numberOfJobStatus += 1
        }
        
        if completedJobs.count > 0 {
            numberOfJobStatus += 1
        }
        
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoAlignAxis(toSuperviewAxis: .vertical)
            tableView.autoMatch(.width, to: .width, of: view)
            tableView.autoPinEdge(toSuperviewMargin: .top)
            tableView.autoPinEdge(toSuperviewMargin: .bottom)
            
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No job found"
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
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! StaffHeaderTableViewCell
//        cell.layoutIfNeeded()
//        cell.setNeedsLayout()
//        
//        return cell.contentView
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StaffJobTableViewCell
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
    
    func filter() {
        let viewController = FilterViewController()
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
