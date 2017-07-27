//
//  ColorPickerViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/29/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate {
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String)
}

class ColorPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var colorPickerDelegate : ColorPickerDelegate?
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var constraintsAdded = false
    
    var colorList = [String]() {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = Global.colorSignin
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        title = "COLORS"
        
        let cancelBarButton = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(cancel))
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = cancelBarButton
            
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let p = ip6(27) / 2
        
        collectionView.backgroundColor = Global.colorBg
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.indicatorStyle = .white
        collectionView.contentInset = UIEdgeInsetsMake(p, p, p, p)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(p, p, p, p)
        layout.minimumLineSpacing = p * 2
        
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 4 - p * 3
        layout.itemSize = CGSize(width: width, height: width)
        
        loadColorList()
        
        view.addSubview(collectionView)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            collectionView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = self.convertHexToUIColor(hexColor: self.colorList[(indexPath as NSIndexPath).row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let clickedHexColor = self.colorList[(indexPath as NSIndexPath).row]
        let clickedUIColor = self.convertHexToUIColor(hexColor: clickedHexColor)
        self.colorPickerDelegate?.colorPickerDidColorSelected(selectedUIColor: clickedUIColor, selectedHexColor: clickedHexColor)
        
        self.closeColorPicker()
    }
    
    fileprivate func loadColorList(){
        let colorFilePath = Bundle.main.path(forResource: "Colors", ofType: "plist")
        let colorNSArray = NSArray(contentsOfFile: colorFilePath!)
        self.colorList = colorNSArray as! [String]
    }
    
    func convertHexToUIColor(hexColor : String) -> UIColor {
        
        let characterSet = CharacterSet.whitespacesAndNewlines as CharacterSet
        var colorString : String = hexColor.trimmingCharacters(in: characterSet)
        
        colorString = colorString.uppercased()
        
        if colorString.hasPrefix("#") {
            colorString =  colorString.substring(from: colorString.characters.index(colorString.startIndex, offsetBy: 1))
        }
        
        if colorString.characters.count != 6 {
            return UIColor.black
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string:colorString).scanHexInt32(&rgbValue)
        let valueRed    = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let valueGreen  = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let valueBlue   = CGFloat(rgbValue & 0x0000FF) / 255.0
        let valueAlpha  = CGFloat(1.0)
        
        return UIColor(red: valueRed, green: valueGreen, blue: valueBlue, alpha: valueAlpha)
    }
    
    func closeColorPicker(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
