//
//  ExpensesViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 4/4/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import INSPhotoGallery
import DZNEmptyDataSet
import SwiftOverlays
import Firebase

class ExpensesViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CameraDelegate  {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let errorLabel = UILabel()
    
    let pictureOfExpensesHeaderView = UIView()
    let pictureOfExpensesHeaderLabel = UILabel()
    
    let pictureOfExpensesView = UIView()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let expensesHeaderView = UIView()
    let expensesHeaderLabel = UILabel()
    
    let expensesView = UIView()
    let expensesTV = UITextView()
    
    var expensesPhotos: [INSPhotoViewable] = [INSPhotoViewable]()
    var expenses = Expenses()
    var job: Job!
    
    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Global.colorBg
        self.view.tintColor = Global.colorSignin
        self.view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = "EXPENSES"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let doneBarButton = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(save))
        doneBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin,NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        pictureOfExpensesHeaderView.backgroundColor = UIColor.clear
        pictureOfExpensesView.backgroundColor = UIColor.clear
        expensesHeaderView.backgroundColor = UIColor.clear
        expensesView.backgroundColor = UIColor.white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        let p = ip6(27) / 2
        
        collectionView.backgroundColor = Global.colorBg
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.indicatorStyle = .white
        collectionView.contentInset = UIEdgeInsetsMake(p, 0, p, p)
        collectionView.showsHorizontalScrollIndicator = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(p, 0, p, p)
        layout.minimumLineSpacing = p
        
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 4 - p * 3
        layout.itemSize = CGSize(width: width, height: width)
        
        pictureOfExpensesHeaderLabel.text = "PICTURE OF EXPENSES"
        pictureOfExpensesHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        pictureOfExpensesHeaderLabel.textAlignment = .left
        pictureOfExpensesHeaderLabel.textColor = Global.colorGray
        pictureOfExpensesHeaderLabel.numberOfLines = 1
        
        expensesHeaderLabel.text = "EXPENSES"
        expensesHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        expensesHeaderLabel.textAlignment = .left
        expensesHeaderLabel.textColor = Global.colorGray
        expensesHeaderLabel.numberOfLines = 1
        
        expensesTV.placeholderText = "Enter expenses"
        expensesTV.shouldHidePlaceholderText = false
        expensesTV.font = UIFont(name: "OpenSans", size: 14)
        expensesTV.textAlignment = .left
        expensesTV.textColor = UIColor.black
        
        pictureOfExpensesHeaderView.addSubview(pictureOfExpensesHeaderLabel)
        pictureOfExpensesView.addSubview(collectionView)
        expensesHeaderView.addSubview(expensesHeaderLabel)
        expensesView.addSubview(expensesTV)
        
        containerView.addSubview(pictureOfExpensesHeaderView)
        containerView.addSubview(pictureOfExpensesView)
        containerView.addSubview(expensesHeaderView)
        containerView.addSubview(expensesView)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    func loadData() {
        
        for imageUrl in job.expenses.imageUrl {
            let url = URL.init(string: imageUrl.image!)
            let photo = INSPhoto(imageURL: url, thumbnailImageURL: url)
            self.expensesPhotos.append(photo)
            
        }
        self.expenses.imageUrl = job.expenses.imageUrl
        self.collectionView.reloadData()
        
        expensesTV.text = job.expenses.descriptionExpenses
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            scrollView.autoPinEdgesToSuperviewEdges()
            
            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: view)
            
            let height: CGFloat = 50
            
            //------------------------------------------------------------------------
            
            pictureOfExpensesHeaderView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            pictureOfExpensesHeaderView.autoPinEdge(toSuperviewEdge: .right)
            pictureOfExpensesHeaderView.autoPinEdge(toSuperviewEdge: .left)
            pictureOfExpensesHeaderView.autoSetDimension(.height, toSize: height)
            
            pictureOfExpensesHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            pictureOfExpensesHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            pictureOfExpensesHeaderLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            pictureOfExpensesHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            pictureOfExpensesView.autoPinEdge(.top, to: .bottom, of: pictureOfExpensesHeaderView)
            pictureOfExpensesView.autoPinEdge(toSuperviewEdge: .right)
            pictureOfExpensesView.autoPinEdge(toSuperviewEdge: .left)
            
            if DeviceType.IS_IPHONE_6P {
                pictureOfExpensesView.autoSetDimension(.height, toSize: 85)
            }
            else {
                pictureOfExpensesView.autoSetDimension(.height, toSize: 70)
            }
            
            collectionView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 20 )
            collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            
            //------------------------------------------------------------------------
            
            expensesHeaderView.autoPinEdge(.top, to: .bottom, of: pictureOfExpensesView)
            expensesHeaderView.autoPinEdge(toSuperviewEdge: .right)
            expensesHeaderView.autoPinEdge(toSuperviewEdge: .left)
            expensesHeaderView.autoSetDimension(.height, toSize: height)
            
            expensesHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            expensesHeaderLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            expensesHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            expensesHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            expensesView.autoPinEdge(.top, to: .bottom, of: expensesHeaderView)
            expensesView.autoPinEdge(toSuperviewEdge: .right)
            expensesView.autoPinEdge(toSuperviewEdge: .left)
            expensesView.autoSetDimension(.height, toSize: 100)
            
            expensesTV.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            expensesTV.autoSetDimension(.height, toSize: 80)
            expensesTV.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            expensesTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No photo found"
        let attrs = [NSFontAttributeName: UIFont(name: "OpenSans", size: 16),
                     NSForegroundColorAttributeName: Global.colorGray]
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expenses.imageUrl.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        
        if indexPath.row == 0 {
            let image = UIImage(named: "i_image_add")
            cell.bindingDataOriginal(image: image!)
        }
        else {
            cell.bindingData(image: expenses.imageUrl[indexPath.row - 1].image!)
        }
        
        cell.photoBtn.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            let indexPath = NSIndexPath(item: indexPath.row, section: 0)
            self.expensesPhotos.remove(at: indexPath.row - 1)
            self.expenses.imageUrl.remove(at: indexPath.row - 1)
            collectionView.deleteItems(at: [indexPath as IndexPath])
            collectionView.reloadData()
        })
        
        let viewProfilePictureAction = UIAlertAction(title: "View Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            var indexPhoto = indexPath.row - 1
            if UserDefaultManager.getInstance().getUserType() {
                indexPhoto = indexPath.row
            }
            
            let indexPath = NSIndexPath(item: indexPath.row, section: 0)
            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! PhotoCollectionViewCell
            let galleryPreview = INSPhotosViewController(photos: self.expensesPhotos, initialPhoto: self.expensesPhotos[indexPhoto], referenceView: cell)
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
            if (indexPath.row == 0) {
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
                self.expensesPhotos.append(photo)
                
                let imageUrl = ImageUrl()
                imageUrl.image = url
                self.expenses.imageUrl.append(imageUrl)
                
                self.collectionView.reloadData()
            }
            else {
                Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        var height: CGFloat!
        
        if DeviceType.IS_IPHONE_6P {
            height = 285
        }
        else {
            height = 270
        }
        
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    var isSaving = false
    
    func save() {
        
        if isSaving {
            return
        }
        
        if expenses.imageUrl.count == 0 {
            Utils.showAlert(title: "Error", message: "Picture of Expenses can not be empty!", viewController: self)
            return
        }
        
        if expensesTV.text == "" {
            Utils.showAlert(title: "Error", message: "Expenses can not be empty!", viewController: self)
            return
        }
        
        isSaving = true
        
        
        SwiftOverlays.showBlockingWaitOverlay()
        expenses.descriptionExpenses = expensesTV.text
        job.expenses = expenses
        
        DatabaseHelper.shared.getUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
            user in
            if user != nil {
                self.job.jobStatus = JobStatus.Complete.rawValue
                self.job.recordJob = 3
                
                DatabaseHelper.shared.saveJob(userId: (user?.adminId)!, job: self.job) {_ in 
                    SwiftOverlays.removeAllBlockingOverlays()
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                let message = Message()
                message.title = (user?.name)! + " completed the job #" + String(self.job.number!)
                message.body = "COMPLETE DATE: " + Utils.getCurrentDate()!
                
                DatabaseHelper.shared.sendMessage(userId: (user?.adminId)!, message: message) {
                    _ in
                    
                }
            }
            else {
                self.isSaving = false
                Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
            }
        }
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
