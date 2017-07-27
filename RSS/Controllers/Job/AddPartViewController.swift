//
//  AddPartViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/29/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

protocol AddPartDelegate {
    func savePart(isCreate: Bool, part: Part)
}

class AddPartViewController: UIViewController, UITextFieldDelegate {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let titleView = UIView()
    let titleLabel = UILabel()
    
    let partNameView = UIView()
    let partNameField = UITextField()
    
    let descriptionView = UIView()
    let descriptionLabel = UILabel()
    
    let descriptionValueView = UIView()
    let descriptionTV = UITextView()
    
    let quantityHeaderView = UIView()
    let quantityHeaderLabel = UILabel()
    
    let quantityView = UIView()
    let quantityLabel = UILabel()
    let substractBtn = UIButton()
    let addBtn = UIButton()
    
    var quantity = 0
    
    var constraintsAdded = false
    var part: Part!
    var isCreate = true

    var addPartDelegate: AddPartDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.addTapToDismiss()
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = Global.colorSignin
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        
        let cancelBarButton = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(cancel))
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        titleView.backgroundColor = UIColor.clear
        partNameView.backgroundColor = UIColor.white
        descriptionView.backgroundColor = UIColor.clear
        descriptionValueView.backgroundColor = UIColor.white
        quantityHeaderView.backgroundColor = UIColor.clear
        quantityView.backgroundColor = UIColor.white
        
        titleLabel.text = "TITLE"
        titleLabel.font = UIFont(name: "OpenSans", size: 15)
        titleLabel.textAlignment = .left
        titleLabel.textColor = Global.colorGray
        titleLabel.numberOfLines = 1
        
        partNameField.delegate = self
        partNameField.textAlignment = .left
        partNameField.placeholder = "Enter Part Name"
        partNameField.textColor = UIColor.black
        partNameField.returnKeyType = .done
        partNameField.keyboardType = .namePhonePad
        partNameField.inputAccessoryView = UIView()
        partNameField.autocorrectionType = .no
        partNameField.autocapitalizationType = .none
        partNameField.font = UIFont(name: "OpenSans-semibold", size: 17)
        partNameField.backgroundColor = UIColor.white
        
        descriptionLabel.text = "DESCRIPTION"
        descriptionLabel.font = UIFont(name: "OpenSans", size: 15)
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = Global.colorGray
        descriptionLabel.numberOfLines = 1
        
        descriptionTV.text = ""
        descriptionTV.font = UIFont(name: "OpenSans", size: 14)
        descriptionTV.textAlignment = .left
        descriptionTV.textColor = UIColor.black
        
        quantityHeaderLabel.text = "QUANTITY"
        quantityHeaderLabel.font = UIFont(name: "OpenSans", size: 15)
        quantityHeaderLabel.textAlignment = .left
        quantityHeaderLabel.textColor = Global.colorGray
        quantityHeaderLabel.numberOfLines = 1
        
        quantityLabel.text = "0"
        quantityLabel.font = UIFont(name: "OpenSans-semibold", size: 17)
        quantityLabel.textAlignment = .center
        quantityLabel.textColor = UIColor.black
        quantityLabel.numberOfLines = 1
        
        substractBtn.setImage(UIImage(named: "i_list_add"), for: .normal)
        substractBtn.backgroundColor = UIColor.clear
        substractBtn.addTarget(self, action: #selector(substractQuantity), for: .touchUpInside)
        substractBtn.clipsToBounds = true
        
        addBtn.setImage(UIImage(named: "i_list_uncheck"), for: .normal)
        addBtn.backgroundColor = UIColor.clear
        addBtn.addTarget(self, action: #selector(addQuantity), for: .touchUpInside)
        addBtn.clipsToBounds = true
        
        titleView.addSubview(titleLabel)
        partNameView.addSubview(partNameField)
        descriptionView.addSubview(descriptionLabel)
        descriptionValueView.addSubview(descriptionTV)
        quantityHeaderView.addSubview(quantityHeaderLabel)
        quantityView.addSubview(quantityLabel)
        quantityView.addSubview(substractBtn)
        quantityView.addSubview(addBtn)
        
        containerView.addSubview(titleView)
        containerView.addSubview(partNameView)
        containerView.addSubview(descriptionView)
        containerView.addSubview(descriptionValueView)
        containerView.addSubview(quantityHeaderView)
        containerView.addSubview(quantityView)
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        loadData()
        
        view.setNeedsUpdateConstraints()
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
            
            titleView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            titleView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            titleView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            titleView.autoSetDimension(.height, toSize: height)
            
            titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            titleLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------
            
            partNameView.autoPinEdge(.top, to: .bottom, of: titleView)
            partNameView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            partNameView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            partNameView.autoSetDimension(.height, toSize: height)
            
            partNameField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            partNameField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            partNameField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            partNameField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            
            //------------------------------------------------------------------------
            
            descriptionView.autoPinEdge(.top, to: .bottom, of: partNameView)
            descriptionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            descriptionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            descriptionView.autoSetDimension(.height, toSize: height)
            
            descriptionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            descriptionLabel.autoSetDimension(.height, toSize: 20)
            
            //------------------------------------------------------------------------

            descriptionValueView.autoPinEdge(.top, to: .bottom, of: descriptionView)
            descriptionValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            descriptionValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            descriptionValueView.autoSetDimension(.height, toSize: 100)
            
            descriptionTV.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            descriptionTV.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            descriptionTV.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            descriptionTV.autoSetDimension(.height, toSize: 80)
            
            //------------------------------------------------------------------------
            
            quantityHeaderView.autoPinEdge(.top, to: .bottom, of: descriptionValueView)
            quantityHeaderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            quantityHeaderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            quantityHeaderView.autoSetDimension(.height, toSize: height)
            
            quantityHeaderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            quantityHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            quantityHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            quantityHeaderLabel.autoSetDimension(.height, toSize: 20)

            //------------------------------------------------------------------------
            
            quantityView.autoPinEdge(.top, to: .bottom, of: quantityHeaderView)
            quantityView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            quantityView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            quantityView.autoSetDimension(.height, toSize: 60)
            
            quantityLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            quantityLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            quantityLabel.autoSetDimension(.width, toSize: 30)
            quantityLabel.autoAlignAxis(toSuperviewAxis: .vertical)
            
            substractBtn.autoSetDimensions(to: CGSize(width: 40, height: 40))
            substractBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            substractBtn.autoPinEdge(.right, to: .left, of: quantityLabel, withOffset: -30)
            
            addBtn.autoSetDimensions(to: CGSize(width: 40, height: 40))
            addBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            addBtn.autoPinEdge(.left, to: .right, of: quantityLabel, withOffset: 30)
        }
    }
    
    func loadData() {
        if UserDefaultManager.getInstance().getUserType() {
            partNameField.isUserInteractionEnabled = false
            descriptionTV.isEditable = false
            addBtn.isHidden = true
            substractBtn.isHidden = true
            
            title = part.name
        }
        else {
            let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(save))
            saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorSignin, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
            self.navigationItem.rightBarButtonItem = saveBarButton
            
            if part == nil {
                title = "ADD PART"
            }
            else {
                title = "EDIT PART"
            }
        }
        
        if part != nil {
            partNameField.text = part.name
            descriptionTV.text = part.partDescription
            quantityLabel.text = String(part.quantity!)
            quantity = part.quantity!
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        let height : CGFloat = 370
        containerView.autoSetDimension(.height, toSize: height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    var isSaving = false
    
    func save() {
        
        if isSaving {
           return
        }
        
        if partNameField.text == "" {
            Utils.showAlert(title: "Error", message: "Part Name can not be empty!", viewController: self)
            return
        }
        
        if descriptionTV.text == "" {
            Utils.showAlert(title: "Error", message: "Description can not be empty!", viewController: self)
            return
        }
        
        isSaving = true
        
        if part == nil {
            part = Part()
        }
        
        part.name = partNameField.text
        part.partDescription = descriptionTV.text
        part.quantity = quantity
        
        if addPartDelegate != nil {
            addPartDelegate.savePart(isCreate: isCreate, part: part)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        part = Part()
        dismiss(animated: true, completion: nil)
    }
    
    func addQuantity() {
        quantity += 1
        quantityLabel.text = String(quantity)
    }
    
    func substractQuantity() {
        if quantity == 0 {
            return
        }
        quantity -= 1
        quantityLabel.text = String(quantity)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        default:
            textField.resignFirstResponder()
            return true
        }
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case partNameField:
            if value != nil && value!.isValidName() {
                return true
            }
        default:
            if value != nil && value!.isValidDescription() {
                return true
            }
        }
        return false
    }
}
