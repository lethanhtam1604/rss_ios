//
//  InvitationViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/22/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import DZNEmptyDataSet
import Firebase

class InvitationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    var constraintsAdded = false

    var allJobs = [Job]()
    var jobs = [Job]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorBg
        view.clipsToBounds = true
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        title = "INVITATION"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = Global.colorSeparator
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(InvitationTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        loadData()
        
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
        
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            
            if user != nil {
                
                DatabaseHelper.shared.getJobsByStaff(userId: (user?.adminId)!, staffId: (FIRAuth.auth()!.currentUser?.uid)!) {
                    jobs in
                    
                    self.indicator.stopAnimating()
                    self.allJobs = jobs
                    
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
        
        jobs.removeAll()
        
        for job in allJobs {
            if (job.assignmentStatus == 1) {
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
            tableView.autoPinEdge(toSuperviewMargin: .top)
            tableView.autoPinEdge(toSuperviewMargin: .bottom)
            
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No invatation found"
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
        return 155
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InvitationTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none
        
        cell.bidingData(job: jobs[indexPath.row])
        
        cell.rejectBtn.tag = indexPath.row
        cell.acceptBtn.tag = indexPath.row
        
        cell.acceptBtn.addTarget(self, action: #selector(accept), for: .touchUpInside)
        cell.rejectBtn.addTarget(self, action: #selector(reject), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = JobDetailViewController()
        viewController.job = jobs[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    var currentIndex = 0
    
    func accept(_ sender: UIButton) {
        currentIndex = sender.tag
        let viewController = AcceptanceViewController()
        viewController.job = jobs[currentIndex]
        navigationController?.pushViewController(viewController, animated: true)
    }

    func reject(_ sender: UIButton) {
        currentIndex = sender.tag
        let viewController = RejectionViewController()
        viewController.job = jobs[currentIndex]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func saveRejection() {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        self.jobs.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
}
