//
//  SignatureViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/29/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import STPopup

protocol SignatureDelegate {
    func saveImage(image: UIImage)
}

class SignatureViewController: UIViewController, ColorPickerDelegate, SignatureSettingDelegate {
    
    let mainImageView = UIImageView()
    let tempImageView = UIImageView()
    let borderView = UIView()
    
    let clearBtn = UIButton()
    let colorBtn = UIButton()
    let settingBtn = UIButton()

    var constraintsAdded = false
    
    var lockDraw = false
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var colorCurrent = UIColor.black
    
    var signatureDelegate: SignatureDelegate!
    var signature: String?
    var signatureLocal: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.tintColor = Global.colorSignin
        
        title = "SIGNATURE"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        clearBtn.setTitle("CLEAR", for: .normal)
        clearBtn.backgroundColor = Global.colorSignin
        clearBtn.setTitleColor(UIColor.white, for: .normal)
        clearBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        clearBtn.addTarget(self, action: #selector(clear), for: .touchUpInside)
        clearBtn.layer.cornerRadius = 5
        clearBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        clearBtn.clipsToBounds = true
        
        colorBtn.setTitle("COLOR", for: .normal)
        colorBtn.backgroundColor = Global.colorSignin
        colorBtn.setTitleColor(UIColor.white, for: .normal)
        colorBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        colorBtn.addTarget(self, action: #selector(color), for: .touchUpInside)
        colorBtn.layer.cornerRadius = 5
        colorBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        colorBtn.clipsToBounds = true
        
        settingBtn.setTitle("SETTING", for: .normal)
        settingBtn.backgroundColor = Global.colorSignin
        settingBtn.setTitleColor(UIColor.white, for: .normal)
        settingBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        settingBtn.addTarget(self, action: #selector(setting), for: .touchUpInside)
        settingBtn.layer.cornerRadius = 5
        settingBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        settingBtn.clipsToBounds = true
        
        borderView.backgroundColor = Global.colorSeparator
        
        mainImageView.sd_setShowActivityIndicatorView(true)
        mainImageView.sd_setIndicatorStyle(.gray)
        
        view.addSubview(borderView)
        view.addSubview(mainImageView)
        view.addSubview(tempImageView)
        view.addSubview(clearBtn)
        view.addSubview(colorBtn)
        view.addSubview(settingBtn)

        loadData()
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            mainImageView.autoPinEdgesToSuperviewEdges()
            tempImageView.autoPinEdgesToSuperviewEdges()
            
            borderView.autoSetDimension(.height, toSize: 0.5)
            borderView.autoMatch(.width, to: .width, of: view)
            borderView.autoPinEdge(toSuperviewMargin: .top)
            borderView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            clearBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            clearBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            clearBtn.autoMatch(.width, to: .width, of: colorBtn)
            
            colorBtn.autoPinEdge(.right, to: .left, of: settingBtn, withOffset: -10)
            colorBtn.autoPinEdge(.left, to: .right, of: clearBtn, withOffset: 10)
            colorBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            
            settingBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            settingBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            settingBtn.autoMatch(.width, to: .width, of: colorBtn)
        }
    }
    
    func loadData() {
        if UserDefaultManager.getInstance().getUserType() {
            clearBtn.isHidden = true
            colorBtn.isHidden = true
            settingBtn.isHidden = true
            
            lockDraw = true
        }
        else {
            let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
            saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
            self.navigationItem.rightBarButtonItem = saveBarButton
        }
        
        if signatureLocal != nil {
            mainImageView.image = signatureLocal
        }
        else if signature != nil {
            mainImageView.sd_setImage(with: URL(string: signature!))
        }
        
    }
    
    func clear() {
        mainImageView.image = nil
    }
    
    func color() {
        showColorPicker()
    }
    
    var settingSignaturePopupController: STPopupController!
    
    func setting() {
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorSignin
        STPopupNavigationBar.appearance().barStyle = .default
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]

        let viewController = SignatureSettingViewController()
        viewController.signatureSettingDelegate = self
        viewController.brushWidth = self.brushWidth
        settingSignaturePopupController = STPopupController(rootViewController: viewController)
        settingSignaturePopupController.containerView.layer.cornerRadius = 4
        settingSignaturePopupController.present(in: self)
    }
    
    func saveSignatureSetting(brushWidth: CGFloat) {
        settingSignaturePopupController.dismiss()
        self.brushWidth = brushWidth
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(lockDraw == true) {
            return
        }
        
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(colorCurrent.cgColor)
        //        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(lockDraw == true) {
            return
        }
        
        swiped = true
        if let touch = touches.first  {
            let currentPoint = touch.location(in: view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(lockDraw == true) {
            return
        }
        
        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil
    }
    
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String) {
        red = selectedUIColor.coreImageColor.red
        green = selectedUIColor.coreImageColor.green
        blue = selectedUIColor.coreImageColor.blue
        colorCurrent = selectedUIColor
    }
    
    func showColorPicker() {
        
        let viewController = ColorPickerViewController()
        viewController.colorPickerDelegate = self
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true, completion: nil)
    }
    
    func save() {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)

        mainImageView.image?.draw(in: CGRect(x: 0, y: 0,
                                             width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if signatureDelegate != nil {
            signatureDelegate.saveImage(image: image!)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
