//
//  DatabaseHelper.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/20/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import Firebase
import Alamofire

class DatabaseHelper: NSObject {
    
    static let shared = DatabaseHelper()
    
    private let databaseRef = FIRDatabase.database().reference()
    private let storageRef = FIRStorage.storage().reference()
    
    //---------------------jobs----------------------------------
    
    func getJobs(userId: String, completion: @escaping ([Job]) -> Void) {
        let ref = self.databaseRef.child("jobs").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var result = [Job]()
                for snap in data {
                    let job = Job(snap)
                    result.append(job)
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }
    
    func getIdMax(userId: String, completion: @escaping (Int) -> Void) {
        var idMax = 99
        let ref = self.databaseRef.child("jobs").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in data {
                    let job = Job(snap)
                    if job.number! > idMax {
                        idMax = job.number!
                    }
                }
                completion(idMax + 1)
            }
            else {
                completion(100)
            }
        })
    }
    
    func observeJobs(userId: String, completion: @escaping (Job) -> Void) {
        let ref = self.databaseRef.child("jobs").child(userId)
        
        ref.observe(.childChanged, with: { snapshot in
            let job = Job(snapshot)
            completion(job)
        })
        
        ref.observe(.childAdded, with: { snapshot in
            let job = Job(snapshot)
            completion(job)
        })
    }
    
    func observeJobChange(userId: String, completion: @escaping (Job) -> Void) {
        let ref = self.databaseRef.child("jobs").child(userId)
        
        ref.observe(.childChanged, with: { snapshot in
            let job = Job(snapshot)
            completion(job)
        })
    }
    
    func saveJob(userId: String, job: Job, completion: @escaping (String) -> Void) {
        var ref = self.databaseRef.child("jobs").child(userId)
        
        var id = job.id
        if job.id.isEmpty {
            ref = ref.childByAutoId()
            id = ref.key
        } else {
            ref = ref.child(job.id)
        }
        
        ref.setValue(job.toAny())
        ref.observeSingleEvent(of: .value, with: { _ in
            completion(id)
        })
    }
    
    func getJobsByStaff(userId: String, staffId: String, completion: @escaping ([Job]) -> Void) {
        let ref = self.databaseRef.child("jobs").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var result = [Job]()
                for snap in data {
                    let job = Job(snap)
                    if staffId == job.assign.staffId {
                        result.append(job)
                    }
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }
    
    func deleteJob(userId: String, job: Job, completion: @escaping () -> Void) {
        let ref = self.databaseRef.child("jobs").child(userId)
        
        ref.child(job.id).removeValue { (error, ref) in
            completion()
        }
    }
    
    func observeDeleteJob(userId: String, completion: @escaping (Job) -> Void) {
        let ref = self.databaseRef.child("jobs").child(userId)
        ref.observe(.childRemoved, with: { snapshot in
            let job = Job(snapshot)
            completion(job)
        })
    }
    
    //---------------------clients-------------------------------
    
    func getClients(userId: String, completion: @escaping ([Client]) -> Void) {
        let ref = self.databaseRef.child("clients").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var result = [Client]()
                for snap in data {
                    let event = Client(snap)
                    result.append(event)
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }
    
    func getClient(clientId: String, userId: String, completion: @escaping (Client?) -> Void) {
        var client: Client?
        let ref = self.databaseRef.child("clients").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var flag = false
                for snap in data {
                    client = Client(snap)
                    if client?.id == clientId {
                        flag = true
                        break
                    }
                }
                
                if flag {
                    completion(client)
                }
                else {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        })
    }
    
    
    func observeClients(userId: String, completion: @escaping (Client) -> Void) {
        let ref = self.databaseRef.child("clients").child(userId)
        
        ref.observe(.childChanged, with: { snapshot in
            let client = Client(snapshot)
            completion(client)
        })
        
        ref.observe(.childAdded, with: { snapshot in
            let client = Client(snapshot)
            completion(client)
        })
    }
    
    func observeDeleteClient(userId: String, completion: @escaping (Client) -> Void) {
        let ref = self.databaseRef.child("clients").child(userId)
        ref.observe(.childRemoved, with: { snapshot in
            let client = Client(snapshot)
            completion(client)
        })
    }
    
    func observeDeleteClients(completion: @escaping (Client) -> Void) {
        let ref = self.databaseRef.child("clients")
        ref.observe(.childRemoved, with: { snapshot in
            let client = Client(snapshot)
            completion(client)
        })
    }
    
    
    func saveClient(userId: String, client: Client, completion: @escaping (String) -> Void) {
        var ref = self.databaseRef.child("clients").child(userId)
        
        var id = client.id
        if client.id.isEmpty {
            ref = ref.childByAutoId()
            id = ref.key
        } else {
            ref = ref.child(client.id)
        }
        
        ref.setValue(client.toAny())
        ref.observeSingleEvent(of: .value, with: { _ in
            completion(id)
        })
    }
    
    func deleteClient(userId: String, client: Client, completion: @escaping () -> Void) {
        let ref = self.databaseRef.child("clients").child(userId)
        
        ref.child(client.id).removeValue { (error, ref) in
            completion()
        }
    }
    
    //---------------------users-------------------------------
    
    func getStaffs(userId: String, completion: @escaping ([User]) -> Void) {
        let ref = self.databaseRef.child("users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var result = [User]()
                for snap in data {
                    let user = User(snap)
                    if user.adminId == userId {
                        result.append(user)
                    }
                }
                completion(result)
            } else {
                completion([])
            }
        })
    }
    
    func getUser(id: String, completion: @escaping (User?) -> Void) {
        var user: User?
        let ref = self.databaseRef.child("users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var flag = false
                for snap in data {
                    user = User(snap)
                    if user?.id == id {
                        flag = true
                        break
                    }
                }
                
                if flag {
                    completion(user)
                }
                else {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        })
    }
    
    func saveUser(user: User, completion: @escaping () -> Void) {
        var ref = self.databaseRef.child("users")
        
        ref = ref.child(user.id)
        
        ref.setValue(user.toAny())
        ref.observeSingleEvent(of: .value, with: { _ in
            completion()
        })
    }
    
    func observeUsers(completion: @escaping (User) -> Void) {
        let ref = self.databaseRef.child("users")
        
        ref.observe(.childChanged, with: { snapshot in
            let user = User(snapshot)
            completion(user)
        })
        
        ref.observe(.childAdded, with: { snapshot in
            let user = User(snapshot)
            completion(user)
        })
    }
    
    func observeDeleteUser(completion: @escaping (User) -> Void) {
        let ref = self.databaseRef.child("users")
        ref.observe(.childRemoved, with: { snapshot in
            let user = User(snapshot)
            completion(user)
        })
    }
    
    func deleteUser(userId: String, completion: @escaping () -> Void) {
        let ref = self.databaseRef.child("users")
        
        ref.child(userId).removeValue { (error, ref) in
            completion()
        }
    }
    
    
    //---------------------storage-------------------------------
    
    func uploadImage(localImage: UIImage, completion: @escaping (String?) -> Void) {
        let data = UIImageJPEGRepresentation(localImage, 1)!
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        
        let ref = storageRef.child("\(UUID().uuidString).jpg")
        ref.put(data, metadata: metadata) {
            (metadata, error) in
            guard let metadata = metadata else {
                completion(nil)
                return
            }
        
            completion(metadata.downloadURL()!.absoluteString)
        }
    }
    
    //---------------------send message-------------------------------

    func sendMessage(userId: String, message: Message, completion: @escaping (Bool) -> Void) {
        let headers = ["Content-Type": "application/json", "Authorization": Global.serverKey]
        let body = ["to": "/topics/" + userId, "priority": "high", "notification" : message.toAny()] as [String : Any]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                completion(true)
                break
            case .failure(_):
                completion(false)
                return
            }
        }
    }
    
    func encodeImage(url: String, completion: @escaping (String?) -> Void) {
        self.storageRef.child(url).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
            completion(data?.base64EncodedString(options: .lineLength64Characters))
        })
    }
}
