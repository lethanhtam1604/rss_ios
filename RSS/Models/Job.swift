//
//  Job.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/25/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase

class Job: NSObject {
    
    var id: String = ""
    var number: Int?
    var jobDescription: String?
    var jobStatus: Int?
    var assignmentStatus: Int?
    var recordJob: Int?
    var arrivedTime: Int?
    var checkoutTime: Int?
    var assign = Assign()
    var accept = Accept()
    var reject = Reject()
    var expenses = Expenses()
    var checkList = CheckList()
    var contacts = [Contact]()
    var invitationSeen: Bool?
    var startTime: String?
    var clientId: String?
    var clientName: String?
    var location = Location()

    convenience init(job: Job) {
        self.init()
        
        id = job.id
        number = job.number
        jobDescription = job.jobDescription
        jobStatus = job.jobStatus
        assignmentStatus = job.assignmentStatus
        recordJob = job.recordJob
        arrivedTime = job.arrivedTime
        checkoutTime = job.checkoutTime
        invitationSeen = job.invitationSeen
        startTime = job.startTime
        clientId = job.clientId
        clientName = job.clientName
        location = job.location
        
        assign = job.assign
        accept = job.accept
        reject = job.reject
        expenses = job.expenses
        checkList = job.checkList

        contacts = []
        contacts.append(contentsOf: job.contacts)
    }
    
    convenience init(_ snapshot: FIRDataSnapshot) {
        self.init()
        id = snapshot.key
        if let value = snapshot.value as? [String:Any] {
            number = value["number"] as? Int
            clientName = value["clientName"] as? String
            jobDescription = value["description"] as? String
            jobStatus = value["jobStatus"] as? Int
            assignmentStatus = value["assignmentStatus"] as? Int
            recordJob = value["recordJob"] as? Int
            arrivedTime = value["arrivedTime"] as? Int
            checkoutTime = value["checkoutTime"] as? Int
            invitationSeen = value["invitationSeen"] as? Bool
            startTime = value["startTime"] as? String
            clientId = value["clientId"] as? String
            
            let locationSnapshot = snapshot.childSnapshot(forPath: "location")
            if locationSnapshot.exists() {
                location = Location(locationSnapshot)
            }

            let assignSnapshot = snapshot.childSnapshot(forPath: "assign")
            if assignSnapshot.exists() {
                assign = Assign(assignSnapshot)
            }
            
            let acceptSnapshot = snapshot.childSnapshot(forPath: "accept")
            if acceptSnapshot.exists() {
                accept = Accept(acceptSnapshot)
            }
            
            let rejectSnapshot = snapshot.childSnapshot(forPath: "reject")
            if rejectSnapshot.exists() {
                reject = Reject(rejectSnapshot)
            }
            
            let expensesSnapshot = snapshot.childSnapshot(forPath: "expenses")
            if expensesSnapshot.exists() {
                expenses = Expenses(expensesSnapshot)
            }
            
            let checkListSnapshot = snapshot.childSnapshot(forPath: "checkList")
            if checkListSnapshot.exists() {
                checkList = CheckList(checkListSnapshot)
            }
            
            let contactSnapshot = snapshot.childSnapshot(forPath: "contacts")
            if let contacts = contactSnapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in contacts {
                    let contact = Contact(snap)
                    self.contacts.append(contact)
                }
            }
        }
    }
    
    func toAny() -> Any {
        var contactArray = [Any]()
        
        for contact in contacts {
            contactArray.append(contact.toAny())
        }
        
        return [
            "number": number ?? 100,
            "assign": assign.toAny(),
            "accept": accept.toAny(),
            "reject": reject.toAny(),
            "checkList": checkList.toAny(),
            "expenses": expenses.toAny(),
            "contacts": contactArray,
            "description": jobDescription ?? "",
            "jobStatus": jobStatus ?? 0,
            "assignmentStatus": assignmentStatus ?? 0,
            "recordJob": recordJob ?? 0,
            "arrivedTime": arrivedTime ?? 0,
            "checkoutTime": checkoutTime ?? 0,
            "invitationSeen": invitationSeen ?? true,
            "startTime": startTime ?? "",
            "clientId": clientId ?? "",
            "clientName": clientName ?? "",
            "location": location.toAny()
        ]
    }
}
