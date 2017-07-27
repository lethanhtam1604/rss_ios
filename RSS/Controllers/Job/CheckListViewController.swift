//
//  CheckListViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/28/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import PureLayout
import DZNEmptyDataSet
import INSPhotoGallery
import SwiftOverlays
import Firebase

class CheckListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AddPartDelegate, CameraDelegate, CheckListHeaderDelegate, CheckListFooterDelegate, SignatureDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    var constraintsAdded = false
    
    var checkListHeader: CheckListHeaderTableViewCell!
    var checkListFooter: CheckListFooterTableViewCell!
    
    var clientName = ""
    var clientAddress = ""
    
    var photoType = 0
    
    var loadedFooter = false
    var loadedHeader = false
    
    var job: Job!
    var parts = [Part]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        
        title = "CHECKLIST"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(PartTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CheckListHeaderTableViewCell.self, forCellReuseIdentifier: "header")
        tableView.register(CheckListFooterTableViewCell.self, forCellReuseIdentifier: "footer")
        tableView.backgroundColor = UIColor.clear
        tableView.estimatedSectionFooterHeight = 490
        tableView.sectionFooterHeight = 490
        
        view.addSubview(tableView)
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    func loadData() {
        parts = job.checkList.parts
        tableView.reloadData()
        
        if !UserDefaultManager.getInstance().getUserType() {
            let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
            saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
            self.navigationItem.rightBarButtonItem = saveBarButton
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !loadedHeader {
            loadedHeader = true
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! CheckListHeaderTableViewCell
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            for imageUrl in job.checkList.photoBefore {
                let url = URL.init(string: imageUrl.image!)
                let photo = INSPhoto(imageURL: url, thumbnailImageURL: url)
                cell.beforePhotos.append(photo)
            }
            
            cell.urlBeforePhotos = job.checkList.photoBefore
            cell.summaryTV.text = job.checkList.summary
            cell.narrativeOfRepairsTV.text = job.checkList.narrativeOfRepairs
            cell.addBtn.addTarget(self, action: #selector(addPart), for: .touchUpInside)
            
            checkListHeader = cell
            
            cell.checkListHeaderDelegate = self
            cell.collectionView.reloadData()
            
            if UserDefaultManager.getInstance().getUserType() {
                
                checkListHeader.addBtn.isHidden = true
                checkListHeader.summaryTV.isEditable = false
                checkListHeader.narrativeOfRepairsTV.isEditable = false
            }
            
            return cell.contentView
        }
        else {
            return checkListHeader.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if DeviceType.IS_IPHONE_6P {
            return 485
        }
        else {
            return 470
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if DeviceType.IS_IPHONE_6P {
            return 505
        }
        else {
            return 490
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if !loadedFooter {
            loadedFooter = true
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "footer") as! CheckListFooterTableViewCell
            cell.layoutIfNeeded()
            cell.setNeedsLayout()
            
            for imageUrl in job.checkList.photoAfter {
                let url = URL.init(string: imageUrl.image!)
                let photo = INSPhoto(imageURL: url, thumbnailImageURL: url)
                cell.afterPhotos.append(photo)
            }
            
            cell.urlAfterPhotos = job.checkList.photoAfter
            cell.followUpRequiredTV.text = job.checkList.followUpDescription
            cell.partNeededTV.text = job.checkList.partDescription
            cell.followUpSwitch.setOn(job.checkList.followUpRequired!, animated: false)
            cell.partNeededSwitch.setOn(job.checkList.partNeeded!, animated: false)
            
            let viewGesture = UITapGestureRecognizer(target: self, action: #selector(signature))
            cell.signatureAbstractView.addGestureRecognizer(viewGesture)
            cell.followUpSwitch.addTarget(self, action: #selector(followUpChanged), for: .valueChanged)
            cell.partNeededSwitch.addTarget(self, action: #selector(partNeededChanged), for: .valueChanged)
            
            checkListFooter = cell
            
            
            if job.checkList.followUpRequired! {
                setFollowUpOn()
            }
            else {
                setFollowUpOff()
            }
            
            if job.checkList.partNeeded! {
                setPartNeededOn()
            }
            else {
                setPartNeededOff()
            }
            
            cell.checkListFooterDelegate = self
            cell.collectionView.reloadData()
            
            if UserDefaultManager.getInstance().getUserType() {
                checkListFooter.followUpSwitch.isUserInteractionEnabled = false
                checkListFooter.followUpRequiredTV.isEditable = false
                checkListFooter.partNeededSwitch.isUserInteractionEnabled = false
                checkListFooter.partNeededTV.isEditable = false
            }
            
            return cell.contentView
        }
        else {
            return checkListFooter.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "DELETE") { action, index in
            self.parts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        delete.backgroundColor = Global.colorDeleteBtn
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PartTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.bidingData(part: parts[indexPath.row])
        
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = AddPartViewController()
        viewController.addPartDelegate = self
        viewController.isCreate = false
        viewController.part = parts[indexPath.row]
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true, completion: nil)
    }
    
    func addPart() {
        let viewController = AddPartViewController()
        viewController.addPartDelegate = self
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true, completion: nil)
    }
    
    func savePart(isCreate: Bool, part: Part) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if isCreate {
                self.parts.append(part)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.parts.count - 1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                let indexPath = NSIndexPath(row: self.self.parts.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: .middle, animated: true)
            }
            else {
                self.tableView.reloadData()
            }
        }
    }
    
    var isSaving = false
    
    func save() {
        
        if isSaving {
            return
        }
        
//        if checkListHeader.urlBeforePhotos.count == 0 {
//            Utils.showAlert(title: "Error", message: "Photo Before can not be empty!", viewController: self)
//            return
//        }
//        
//        if checkListHeader.summaryTV.text == "" {
//            Utils.showAlert(title: "Error", message: "Summary can not be empty!", viewController: self)
//            return
//        }
//        
//        if checkListHeader.narrativeOfRepairsTV.text == "" {
//            Utils.showAlert(title: "Error", message: "Narrative of Repairs can not be empty!", viewController: self)
//            return
//        }
//        
//        if parts.count == 0 {
//            Utils.showAlert(title: "Error", message: "Parts Used can not be empty!", viewController: self)
//            return
//        }
//        
//        if checkListFooter == nil {
//            if job.checkList.photoAfter.count == 0 {
//                Utils.showAlert(title: "Error", message: "Photo After can not be empty!", viewController: self)
//                return
//            }
//            
//            if job.checkList.followUpRequired! && job.checkList.followUpDescription == "" {
//                Utils.showAlert(title: "Error", message: "Follow up can not be empty!", viewController: self)
//                return
//            }
//            
//            if job.checkList.partNeeded! && job.checkList.partDescription == "" {
//                Utils.showAlert(title: "Error", message: "Part can not be empty!", viewController: self)
//                return
//            }
//        }
//        else {
//            if checkListFooter.urlAfterPhotos.count == 0 {
//                Utils.showAlert(title: "Error", message: "Photo After can not be empty!", viewController: self)
//                return
//            }
//            
//            if checkListFooter.followUpSwitch.isOn && checkListFooter.followUpRequiredTV.text == "" {
//                Utils.showAlert(title: "Error", message: "Follow up can not be empty!", viewController: self)
//                return
//            }
//            
//            if checkListFooter.partNeededSwitch.isOn && checkListFooter.partNeededTV.text == "" {
//                Utils.showAlert(title: "Error", message: "Part can not be empty!", viewController: self)
//                return
//            }
//        }
        
        isSaving = true
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        job.checkList.photoBefore = checkListHeader.urlBeforePhotos
        job.checkList.summary = checkListHeader.summaryTV.text
        job.checkList.narrativeOfRepairs = checkListHeader.narrativeOfRepairsTV.text
        job.checkList.parts = parts

        if checkListFooter != nil {
            job.checkList.photoAfter = checkListFooter.urlAfterPhotos
            job.checkList.followUpDescription = checkListFooter.followUpRequiredTV.text
            job.checkList.partDescription = checkListFooter.partNeededTV.text
            job.checkList.followUpRequired = checkListFooter.followUpSwitch.isOn
            job.checkList.partNeeded = checkListFooter.partNeededSwitch.isOn
        }
        
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            if user != nil {
                if self.job.checkList.signatureLocal != nil {
                    DatabaseHelper.shared.uploadImage(localImage: self.job.checkList.signatureLocal!) {
                        url in
                        self.job.checkList.signature = url
                        DatabaseHelper.shared.saveJob(userId: (user?.adminId)!, job: self.job) {_ in 
                            SwiftOverlays.removeAllBlockingOverlays()
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                else {
                    DatabaseHelper.shared.saveJob(userId: (user?.adminId)!, job: self.job) {_ in 
                        SwiftOverlays.removeAllBlockingOverlays()
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else {
                self.isSaving = false
                Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
            }
        }
    }
    
    func cancel() {
        job.checkList.signatureLocal = nil
        _ = navigationController?.popViewController(animated: true)
    }
    
    func signature() {
        let viewController = SignatureViewController()
        viewController.signatureDelegate = self
        viewController.signature = job.checkList.signature
        viewController.signatureLocal = job.checkList.signatureLocal
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func saveImage(image: UIImage) {
        job.checkList.signatureLocal = image
    }
    
    func followUpChanged(_sender: UISwitch) {
        if _sender.isOn {
            setFollowUpOn()
        } else {
            setFollowUpOff()
        }
    }
    
    func partNeededChanged(_sender: UISwitch) {
        if _sender.isOn {
            setPartNeededOn()
        } else {
            setPartNeededOff()
        }
    }
    
    func setFollowUpOn() {
        checkListFooter.followUpSwitch.thumbTintColor = Global.colorSwitchBtn
        checkListFooter.followUpRequiredTV.textColor = UIColor.black
        checkListFooter.followUpRequiredTV.isUserInteractionEnabled = true
    }
    
    func setFollowUpOff() {
        checkListFooter.followUpSwitch.thumbTintColor = Global.colorGray
        checkListFooter.followUpRequiredTV.textColor = Global.colorGray
        checkListFooter.followUpRequiredTV.isUserInteractionEnabled = false
    }
    
    func setPartNeededOn() {
        checkListFooter.partNeededSwitch.thumbTintColor = Global.colorSwitchBtn
        checkListFooter.partNeededTV.textColor = UIColor.black
        checkListFooter.partNeededTV.isUserInteractionEnabled = true
    }
    
    func setPartNeededOff() {
        checkListFooter.partNeededSwitch.thumbTintColor = Global.colorGray
        checkListFooter.partNeededTV.textColor = Global.colorGray
        checkListFooter.partNeededTV.isUserInteractionEnabled = false
    }
    
    func photoBeforeClick(index: Int) {
        photoType = 0
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorSignin
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            self.present(cameraViewController, animated: false, completion: nil)
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            cameraViewController.pickImage = 1
            self.present(cameraViewController, animated: false, completion: nil)
        })
        
        let deletePhotoAction = UIAlertAction(title: "Delete Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let indexPath = NSIndexPath(item: index, section: 0)
            self.checkListHeader.beforePhotos.remove(at: index - 1)
            self.checkListHeader.urlBeforePhotos.remove(at: index - 1)
            self.checkListHeader.collectionView.deleteItems(at: [indexPath as IndexPath])
            self.checkListHeader.collectionView.reloadData()
        })
        
        let viewProfilePictureAction = UIAlertAction(title: "View Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            var indexPhoto = index - 1
            if UserDefaultManager.getInstance().getUserType() {
                indexPhoto = index
            }
            
            let indexPath = NSIndexPath(item: index, section: 0)
            let cell = self.checkListHeader.collectionView.cellForItem(at: indexPath as IndexPath) as! PhotoCollectionViewCell
            let galleryPreview = INSPhotosViewController(photos: self.checkListHeader.beforePhotos, initialPhoto: self.checkListHeader.beforePhotos[indexPhoto], referenceView: cell)
            let overlayViewBar = (galleryPreview.overlayView as! INSPhotosOverlayView).navigationBar
            
            overlayViewBar?.autoPin(toTopLayoutGuideOf: galleryPreview, withInset: 0.0)
            
            galleryPreview.view.backgroundColor = UIColor.black
            galleryPreview.view.tintColor = UIColor.white
            self.present(galleryPreview, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        if UserDefaultManager.getInstance().getUserType() {
            optionMenu.addAction(viewProfilePictureAction)
        }
        else {
            if (index == 0) {
                optionMenu.addAction(takePhotoAction)
                optionMenu.addAction(photoLibraryAction)
            }
            else {
                optionMenu.addAction(deletePhotoAction)
                optionMenu.addAction(viewProfilePictureAction)
            }
        }
        
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func tookPicture(url: String, image: UIImage) {
        SwiftOverlays.showBlockingWaitOverlay()
        DatabaseHelper.shared.uploadImage(localImage: image) {
            url in
            if url != nil {
                SwiftOverlays.removeAllBlockingOverlays()
                let photo = INSPhoto(image: image, thumbnailImage: image)
                
                let imageUrl = ImageUrl()
                imageUrl.image = url
                
                if self.photoType == 0 {
                    self.checkListHeader.beforePhotos.append(photo)
                    self.checkListHeader.urlBeforePhotos.append(imageUrl)
                    self.checkListHeader.collectionView.reloadData()
                }
                else {
                    self.checkListFooter.afterPhotos.append(photo)
                    self.checkListFooter.urlAfterPhotos.append(imageUrl)
                    self.checkListFooter.collectionView.reloadData()
                }
            }
            else {
                Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
            }
        }
    }
    
    func photoAfterClick(index: Int) {
        photoType = 1
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorSignin
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            self.present(cameraViewController, animated: false, completion: nil)
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            cameraViewController.pickImage = 1
            self.present(cameraViewController, animated: false, completion: nil)
        })
        
        let deletePhotoAction = UIAlertAction(title: "Delete Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let indexPath = NSIndexPath(item: index, section: 0)
            self.checkListFooter.afterPhotos.remove(at: index - 1)
            self.checkListFooter.urlAfterPhotos.remove(at: index - 1)
            self.checkListFooter.collectionView.deleteItems(at: [indexPath as IndexPath])
            self.checkListFooter.collectionView.reloadData()
        })
        
        let viewProfilePictureAction = UIAlertAction(title: "View Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            var indexPhoto = index - 1
            if UserDefaultManager.getInstance().getUserType() {
                indexPhoto = index
            }
            
            let indexPath = NSIndexPath(item: index, section: 0)
            let cell = self.checkListFooter.collectionView.cellForItem(at: indexPath as IndexPath) as! PhotoCollectionViewCell
            let galleryPreview = INSPhotosViewController(photos: self.checkListFooter.afterPhotos, initialPhoto: self.checkListFooter.afterPhotos[indexPhoto], referenceView: cell)
            let overlayViewBar = (galleryPreview.overlayView as! INSPhotosOverlayView).navigationBar
            
            overlayViewBar?.autoPin(toTopLayoutGuideOf: galleryPreview, withInset: 0.0)
            
            galleryPreview.view.backgroundColor = UIColor.black
            galleryPreview.view.tintColor = UIColor.white
            self.present(galleryPreview, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        if UserDefaultManager.getInstance().getUserType() {
            optionMenu.addAction(viewProfilePictureAction)
        }
        else {
            if (index == 0) {
                optionMenu.addAction(takePhotoAction)
                optionMenu.addAction(photoLibraryAction)
            }
            else {
                optionMenu.addAction(deletePhotoAction)
                optionMenu.addAction(viewProfilePictureAction)
            }
        }
        
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}
