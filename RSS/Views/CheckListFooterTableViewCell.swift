//
//  CheckListFooterTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/29/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import INSPhotoGallery
import DZNEmptyDataSet

protocol CheckListFooterDelegate {
    func photoAfterClick(index: Int)
}

class CheckListFooterTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    let photoAfterHeaderView = UIView()
    let photoAfterHeaderLabel = UILabel()
    
    let photoAfterView = UIView()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    let followUpRequiredHeaderView = UIView()
    let followUpRequiredHeaderLabel = UILabel()
    
    let followUpRequiredView = UIView()
    let followUpRequiredTV = UITextView()
    let followUpSwitch = UISwitch()
    
    let partNeededHeaderView = UIView()
    let partNeededHeaderLabel = UILabel()
    
    let partNeededView = UIView()
    let partNeededTV = UITextView()
    let partNeededSwitch = UISwitch()

    let signatureView = UIView()
    let signatureAbstractView = UIView()
    let signatureLabel = UILabel()
    let arrowRightImgView = UIImageView()
    
    var constraintAdded = false
    var afterPhotos: [INSPhotoViewable] = [INSPhotoViewable]()
    var urlAfterPhotos = [ImageUrl]()

    var checkListFooterDelegate: CheckListFooterDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.clear
        tintColor = Global.colorSignin
        
        photoAfterHeaderView.backgroundColor = UIColor.clear
        photoAfterView.backgroundColor = UIColor.clear
        followUpRequiredHeaderView.backgroundColor = UIColor.clear
        followUpRequiredView.backgroundColor = UIColor.white
        partNeededHeaderView.backgroundColor = UIColor.clear
        partNeededView.backgroundColor = UIColor.white
        signatureView.backgroundColor = UIColor.white
        signatureAbstractView.backgroundColor = UIColor.clear
        signatureAbstractView.touchHighlightingStyle = .lightBackground
        
        let p = ip6(27) / 2
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        collectionView.backgroundColor = Global.colorBg
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.indicatorStyle = .white
        collectionView.contentInset = UIEdgeInsetsMake(p, 0, p, p)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.reloadData()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(p, 0, p, p)
        layout.minimumLineSpacing = p
        
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 4 - p * 3
        layout.itemSize = CGSize(width: width, height: width)
        
        photoAfterHeaderLabel.text = "PHOTO AFTER"
        photoAfterHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        photoAfterHeaderLabel.textAlignment = .left
        photoAfterHeaderLabel.textColor = Global.colorGray
        photoAfterHeaderLabel.numberOfLines = 1
        
        followUpRequiredHeaderLabel.text = "IS ANY FOLLOW UP REQUIRED?"
        followUpRequiredHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        followUpRequiredHeaderLabel.textAlignment = .left
        followUpRequiredHeaderLabel.textColor = Global.colorGray
        followUpRequiredHeaderLabel.numberOfLines = 1
        
        followUpSwitch.onTintColor = Global.colorSwitchBg
        followUpSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        followUpSwitch.thumbTintColor = Global.colorSwitchBtn

        partNeededSwitch.onTintColor = Global.colorSwitchBg
        partNeededSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        partNeededSwitch.thumbTintColor = Global.colorSwitchBtn
        
        followUpRequiredTV.placeholderText = "Enter details about what follow up is required?"
        followUpRequiredTV.font = UIFont(name: "OpenSans", size: 14)
        followUpRequiredTV.textAlignment = .left
        followUpRequiredTV.textColor = UIColor.black
        
        partNeededHeaderLabel.text = "IS ANY PART NEEDED?"
        partNeededHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        partNeededHeaderLabel.textAlignment = .left
        partNeededHeaderLabel.textColor = Global.colorGray
        partNeededHeaderLabel.numberOfLines = 1
        
        partNeededTV.placeholderText = "Enter details about what parts are needed?"
        partNeededTV.font = UIFont(name: "OpenSans", size: 14)
        partNeededTV.textAlignment = .left
        partNeededTV.textColor = UIColor.black
        
        signatureLabel.text = "Custom Signature"
        signatureLabel.font = UIFont(name: "OpenSans-semibold", size: 16)
        signatureLabel.textAlignment = .left
        signatureLabel.textColor = UIColor.black
        signatureLabel.numberOfLines = 1
        
        arrowRightImgView.clipsToBounds = true
        arrowRightImgView.contentMode = .scaleAspectFit
        arrowRightImgView.image = UIImage(named: "ArrowRight")
        
        if followUpSwitch.isOn {
            followUpSwitch.thumbTintColor = Global.colorSwitchBtn
            followUpRequiredTV.textColor = UIColor.black
            followUpRequiredTV.isUserInteractionEnabled = true
        } else {
            followUpSwitch.thumbTintColor = Global.colorGray
            followUpRequiredTV.textColor = Global.colorGray
            followUpRequiredTV.isUserInteractionEnabled = false
        }
        
        if partNeededSwitch.isOn {
            partNeededSwitch.thumbTintColor = Global.colorSwitchBtn
            partNeededTV.textColor = UIColor.black
            partNeededTV.isUserInteractionEnabled = true
        } else {
            partNeededSwitch.thumbTintColor = Global.colorGray
            partNeededTV.textColor = Global.colorGray
            partNeededTV.isUserInteractionEnabled = false
        }
        
        photoAfterHeaderView.addSubview(photoAfterHeaderLabel)
        photoAfterView.addSubview(collectionView)
        followUpRequiredHeaderView.addSubview(followUpRequiredHeaderLabel)
        followUpRequiredHeaderView.addSubview(followUpSwitch)
        followUpRequiredView.addSubview(followUpRequiredTV)
        partNeededHeaderView.addSubview(partNeededHeaderLabel)
        partNeededHeaderView.addSubview(partNeededSwitch)
        partNeededView.addSubview(partNeededTV)
        
        signatureView.addSubview(signatureLabel)
        signatureView.addSubview(arrowRightImgView)
        signatureView.addSubview(signatureAbstractView)

        contentView.addSubview(photoAfterHeaderView)
        contentView.addSubview(photoAfterView)
        contentView.addSubview(followUpRequiredHeaderView)
        contentView.addSubview(followUpRequiredView)
        contentView.addSubview(partNeededHeaderView)
        contentView.addSubview(partNeededView)
        contentView.addSubview(signatureView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true
            
            let height: CGFloat = 50
            
            //------------------------------------------------------------------------
            
            photoAfterHeaderView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            photoAfterHeaderView.autoPinEdge(toSuperviewEdge: .right)
            photoAfterHeaderView.autoPinEdge(toSuperviewEdge: .left)
            photoAfterHeaderView.autoSetDimension(.height, toSize: height)
            
            photoAfterHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            photoAfterHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            photoAfterHeaderLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            photoAfterHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            photoAfterView.autoPinEdge(.top, to: .bottom, of: photoAfterHeaderView)
            photoAfterView.autoPinEdge(toSuperviewEdge: .right)
            photoAfterView.autoPinEdge(toSuperviewEdge: .left)
            
            if DeviceType.IS_IPHONE_6P {
                photoAfterView.autoSetDimension(.height, toSize: 85)
            }
            else {
                photoAfterView.autoSetDimension(.height, toSize: 70)
            }
            
            collectionView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 20 )
            collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            
            //------------------------------------------------------------------------
            
            followUpRequiredHeaderView.autoPinEdge(.top, to: .bottom, of: photoAfterView)
            followUpRequiredHeaderView.autoPinEdge(toSuperviewEdge: .right)
            followUpRequiredHeaderView.autoPinEdge(toSuperviewEdge: .left)
            followUpRequiredHeaderView.autoSetDimension(.height, toSize: height)
            
            followUpRequiredHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            followUpRequiredHeaderLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            followUpRequiredHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            followUpRequiredHeaderLabel.autoPinEdge(.right, to: .left, of: followUpSwitch, withOffset: 10)
            
            followUpSwitch.autoSetDimensions(to: CGSize(width: 30, height: 30))
            followUpSwitch.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
            followUpSwitch.autoPinEdge(toSuperviewEdge: .top, withInset: 15)

            //------------------------------------------------------------------------
            
            followUpRequiredView.autoPinEdge(.top, to: .bottom, of: followUpRequiredHeaderView)
            followUpRequiredView.autoPinEdge(toSuperviewEdge: .right)
            followUpRequiredView.autoPinEdge(toSuperviewEdge: .left)
            followUpRequiredView.autoSetDimension(.height, toSize: 100)
            
            followUpRequiredTV.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            followUpRequiredTV.autoSetDimension(.height, toSize: 80)
            followUpRequiredTV.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            followUpRequiredTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            partNeededHeaderView.autoPinEdge(.top, to: .bottom, of: followUpRequiredView)
            partNeededHeaderView.autoPinEdge(toSuperviewEdge: .right)
            partNeededHeaderView.autoPinEdge(toSuperviewEdge: .left)
            partNeededHeaderView.autoSetDimension(.height, toSize: height)
            
            partNeededHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            partNeededHeaderLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            partNeededHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            partNeededHeaderLabel.autoPinEdge(.right, to: .left, of: partNeededSwitch, withOffset: 10)
            
            partNeededSwitch.autoSetDimensions(to: CGSize(width: 30, height: 30))
            partNeededSwitch.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
            partNeededSwitch.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
            
            //------------------------------------------------------------------------
            
            partNeededView.autoPinEdge(.top, to: .bottom, of: partNeededHeaderView)
            partNeededView.autoPinEdge(toSuperviewEdge: .right)
            partNeededView.autoPinEdge(toSuperviewEdge: .left)
            partNeededView.autoSetDimension(.height, toSize: 100)
            
            partNeededTV.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            partNeededTV.autoSetDimension(.height, toSize: 80)
            partNeededTV.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            partNeededTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            signatureView.autoPinEdge(.top, to: .bottom, of: partNeededView, withOffset: 10)
            signatureView.autoPinEdge(toSuperviewEdge: .right)
            signatureView.autoPinEdge(toSuperviewEdge: .left)
            signatureView.autoSetDimension(.height, toSize: 60)
            
            signatureLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            signatureLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            signatureLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            signatureLabel.autoPinEdge(.right, to: .left, of: arrowRightImgView, withOffset: 10)
            
            arrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            arrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            arrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            signatureAbstractView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserDefaultManager.getInstance().getUserType() {
            return self.afterPhotos.count
        }
        return self.afterPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        
        if UserDefaultManager.getInstance().getUserType() {
            cell.bindingData(image: urlAfterPhotos[indexPath.row].image!)
        }
        else {
            if indexPath.row == 0 {
                let image = UIImage(named: "i_image_add")
                cell.bindingDataOriginal(image: image!)
            }
            else {
                cell.bindingData(image: urlAfterPhotos[indexPath.row - 1].image!)
            }
        }
        
        cell.photoBtn.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if checkListFooterDelegate != nil {
            checkListFooterDelegate.photoAfterClick(index: indexPath.row)
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No photo found"
        let attrs = [NSFontAttributeName: UIFont(name: "OpenSans", size: 16),
                     NSForegroundColorAttributeName: Global.colorGray]
        return NSAttributedString(string: text, attributes: attrs)
    }
}
