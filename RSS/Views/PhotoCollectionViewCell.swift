//
//  PhotoCollectionViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/30/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var photoBtn = UIImageView()
    var constraintAdded = false
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = Global.colorBg
        
        let tintedImage = UIImage(named: "i_image_add")?.withRenderingMode(.alwaysTemplate)
        photoBtn.image = tintedImage
        photoBtn.tintColor = Global.colorSignin
        photoBtn.clipsToBounds = true
        photoBtn.contentMode = .scaleAspectFill
        photoBtn.layer.cornerRadius = 5
        photoBtn.backgroundColor = UIColor.clear
        photoBtn.sd_setShowActivityIndicatorView(true)
        photoBtn.sd_setIndicatorStyle(.gray)

        addSubview(photoBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true
            
            photoBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
            photoBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
            photoBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            photoBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        }
    }

    func bindingData(image: String) {
        photoBtn.sd_setImage(with: URL(string: image))
    }
    
    func bindingDataOriginal(image: UIImage) {
        photoBtn.image = image
    }
}
