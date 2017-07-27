//
//  CheckListHeaderTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/28/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import INSPhotoGallery
import DZNEmptyDataSet

protocol CheckListHeaderDelegate {
    func photoBeforeClick(index: Int)
}

class CheckListHeaderTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    let photoBeforeHeaderView = UIView()
    let photoBeforeHeaderLabel = UILabel()
    
    let photoBeforeView = UIView()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    let summaryHeaderView = UIView()
    let summaryHeaderLabel = UILabel()
    
    let summaryView = UIView()
    let summaryTV = UITextView()
    
    let narrativeOfRepairsHeaderView = UIView()
    let narrativeOfRepairsHeaderLabel = UILabel()
    
    let narrativeOfRepairsView = UIView()
    let narrativeOfRepairsTV = UITextView()
    
    let partsUsedHeaderView = UIView()
    let partsUserLabel = UILabel()
    let addBtn = UIButton(type: .custom)
    
    var constraintAdded = false
    
    var beforePhotos: [INSPhotoViewable] = [INSPhotoViewable]()
    var checkListHeaderDelegate: CheckListHeaderDelegate!
    
    var urlBeforePhotos = [ImageUrl]()

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
        
        photoBeforeHeaderView.backgroundColor = UIColor.clear
        photoBeforeView.backgroundColor = UIColor.clear
        summaryHeaderView.backgroundColor = UIColor.clear
        summaryView.backgroundColor = UIColor.white
        narrativeOfRepairsHeaderView.backgroundColor = UIColor.clear
        narrativeOfRepairsView.backgroundColor = UIColor.white
        partsUsedHeaderView.backgroundColor = UIColor.clear
        
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
        
        collectionView.reloadData()

        photoBeforeHeaderLabel.text = "PHOTO BEFORE"
        photoBeforeHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        photoBeforeHeaderLabel.textAlignment = .left
        photoBeforeHeaderLabel.textColor = Global.colorGray
        photoBeforeHeaderLabel.numberOfLines = 1
        
        summaryHeaderLabel.text = "SUMMARY"
        summaryHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        summaryHeaderLabel.textAlignment = .left
        summaryHeaderLabel.textColor = Global.colorGray
        summaryHeaderLabel.numberOfLines = 1
        
        summaryTV.placeholderText = "Enter summary"
        summaryTV.font = UIFont(name: "OpenSans", size: 14)
        summaryTV.textAlignment = .left
        summaryTV.textColor = UIColor.black
        
        narrativeOfRepairsHeaderLabel.text = "NARRATIVE OF REPAIRS"
        narrativeOfRepairsHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        narrativeOfRepairsHeaderLabel.textAlignment = .left
        narrativeOfRepairsHeaderLabel.textColor = Global.colorGray
        narrativeOfRepairsHeaderLabel.numberOfLines = 1
        
        narrativeOfRepairsTV.placeholderText = "Enter narrative of repairs"
        narrativeOfRepairsTV.font = UIFont(name: "OpenSans", size: 14)
        narrativeOfRepairsTV.textAlignment = .left
        narrativeOfRepairsTV.textColor = UIColor.black
        
        partsUserLabel.text = "PARTS USED"
        partsUserLabel.font = UIFont(name: "OpenSans", size: 15)
        partsUserLabel.textAlignment = .left
        partsUserLabel.textColor = Global.colorGray
        partsUserLabel.numberOfLines = 1
        
        addBtn.backgroundColor = UIColor.clear
        addBtn.clipsToBounds = true
        addBtn.contentMode = .scaleAspectFit
        let tintedImage = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        addBtn.setImage(tintedImage, for: .normal)
        addBtn.setImage(UIImage(named: "add"), for: .highlighted)
        addBtn.tintColor = Global.colorSignin
        
        photoBeforeHeaderView.addSubview(photoBeforeHeaderLabel)
        photoBeforeView.addSubview(collectionView)
        summaryHeaderView.addSubview(summaryHeaderLabel)
        summaryView.addSubview(summaryTV)
        narrativeOfRepairsHeaderView.addSubview(narrativeOfRepairsHeaderLabel)
        narrativeOfRepairsView.addSubview(narrativeOfRepairsTV)
        
        partsUsedHeaderView.addSubview(partsUserLabel)
        partsUsedHeaderView.addSubview(addBtn)
        
        contentView.addSubview(photoBeforeHeaderView)
        contentView.addSubview(photoBeforeView)
        contentView.addSubview(summaryHeaderView)
        contentView.addSubview(summaryView)
        contentView.addSubview(narrativeOfRepairsHeaderView)
        contentView.addSubview(narrativeOfRepairsView)
        contentView.addSubview(partsUsedHeaderView)

        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true
            
            let height: CGFloat = 50
            
            //------------------------------------------------------------------------
            
            photoBeforeHeaderView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            photoBeforeHeaderView.autoPinEdge(toSuperviewEdge: .right)
            photoBeforeHeaderView.autoPinEdge(toSuperviewEdge: .left)
            photoBeforeHeaderView.autoSetDimension(.height, toSize: height)
            
            photoBeforeHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            photoBeforeHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            photoBeforeHeaderLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            photoBeforeHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            photoBeforeView.autoPinEdge(.top, to: .bottom, of: photoBeforeHeaderView)
            photoBeforeView.autoPinEdge(toSuperviewEdge: .right)
            photoBeforeView.autoPinEdge(toSuperviewEdge: .left)
            
            if DeviceType.IS_IPHONE_6P {
                photoBeforeView.autoSetDimension(.height, toSize: 85)
            }
            else {
                photoBeforeView.autoSetDimension(.height, toSize: 70)
            }
            
            collectionView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 20 )
            collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            
            //------------------------------------------------------------------------
            
            summaryHeaderView.autoPinEdge(.top, to: .bottom, of: photoBeforeView)
            summaryHeaderView.autoPinEdge(toSuperviewEdge: .right)
            summaryHeaderView.autoPinEdge(toSuperviewEdge: .left)
            summaryHeaderView.autoSetDimension(.height, toSize: height)
            
            summaryHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            summaryHeaderLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            summaryHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            summaryHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            summaryView.autoPinEdge(.top, to: .bottom, of: summaryHeaderView)
            summaryView.autoPinEdge(toSuperviewEdge: .right)
            summaryView.autoPinEdge(toSuperviewEdge: .left)
            summaryView.autoSetDimension(.height, toSize: 100)
            
            summaryTV.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            summaryTV.autoSetDimension(.height, toSize: 80)
            summaryTV.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            summaryTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            narrativeOfRepairsHeaderView.autoPinEdge(.top, to: .bottom, of: summaryView)
            narrativeOfRepairsHeaderView.autoPinEdge(toSuperviewEdge: .right)
            narrativeOfRepairsHeaderView.autoPinEdge(toSuperviewEdge: .left)
            narrativeOfRepairsHeaderView.autoSetDimension(.height, toSize: height)
            
            narrativeOfRepairsHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            narrativeOfRepairsHeaderLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            narrativeOfRepairsHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            narrativeOfRepairsHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            narrativeOfRepairsView.autoPinEdge(.top, to: .bottom, of: narrativeOfRepairsHeaderView)
            narrativeOfRepairsView.autoPinEdge(toSuperviewEdge: .right)
            narrativeOfRepairsView.autoPinEdge(toSuperviewEdge: .left)
            narrativeOfRepairsView.autoSetDimension(.height, toSize: 100)
            
            narrativeOfRepairsTV.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            narrativeOfRepairsTV.autoSetDimension(.height, toSize: 80)
            narrativeOfRepairsTV.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            narrativeOfRepairsTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            partsUsedHeaderView.autoPinEdge(.top, to: .bottom, of: narrativeOfRepairsView)
            partsUsedHeaderView.autoPinEdge(toSuperviewEdge: .right)
            partsUsedHeaderView.autoPinEdge(toSuperviewEdge: .left)
            partsUsedHeaderView.autoSetDimension(.height, toSize: height)
            
            partsUserLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            partsUserLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            partsUserLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            partsUserLabel.autoPinEdge(.right, to: .left, of: addBtn, withOffset: 10)
            
            addBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            addBtn.autoSetDimensions(to: CGSize(width: 50, height: 50))
            addBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserDefaultManager.getInstance().getUserType() {
            return self.beforePhotos.count
        }
        return self.beforePhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        
        if UserDefaultManager.getInstance().getUserType() {
            cell.bindingData(image: urlBeforePhotos[indexPath.row].image!)
        }
        else {
            if indexPath.row == 0 {
                let image = UIImage(named: "i_image_add")
                cell.bindingDataOriginal(image: image!)
            }
            else {
                cell.bindingData(image: urlBeforePhotos[indexPath.row - 1].image!)
            }
        }
        
        cell.photoBtn.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if checkListHeaderDelegate != nil {
            checkListHeaderDelegate.photoBeforeClick(index: indexPath.row)
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No photo found"
        let attrs = [NSFontAttributeName: UIFont(name: "OpenSans", size: 16),
                     NSForegroundColorAttributeName: Global.colorGray]
        return NSAttributedString(string: text, attributes: attrs)
    }
}
