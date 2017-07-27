//
//  SignatureSettingViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/30/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import STPopup

protocol SignatureSettingDelegate {
    func saveSignatureSetting(brushWidth: CGFloat)
}

class SignatureSettingViewController: UIViewController {
    
    var sliderBrush = UISlider()
    var signatureSettingDelegate: SignatureSettingDelegate!
    
    var brushWidth: CGFloat = 10

    var constraintsAdded = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SETTING"
        
        self.contentSizeInPopup = CGSize(width: Global.SCREEN_WIDTH - 50, height: Global.SCREEN_HEIGHT - 200)
        self.landscapeContentSizeInPopup = CGSize(width: Global.SCREEN_HEIGHT - 200, height: Global.SCREEN_WIDTH - 100)
        
        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
        saveBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        sliderBrush.minimumValue = 1
        sliderBrush.maximumValue = 80
        sliderBrush.tintColor = Global.colorSignin
        sliderBrush.value = Float(brushWidth)
        sliderBrush.addTarget(self, action: #selector(sliderBrushChanged), for: .valueChanged)
        view.addSubview(sliderBrush)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            sliderBrush.autoAlignAxis(toSuperviewAxis: .horizontal)
            sliderBrush.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
            sliderBrush.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
            sliderBrush.autoSetDimension(.height, toSize: 30)
        }
    }
    
    func sliderBrushChanged(_ sender: UISlider) {
        brushWidth = CGFloat(sender.value)
    }
    
    func save() {
        if signatureSettingDelegate != nil {
            signatureSettingDelegate.saveSignatureSetting(brushWidth: brushWidth)
        }
    }
}
