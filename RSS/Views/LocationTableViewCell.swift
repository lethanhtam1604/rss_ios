//
//  LocationTableViewCell.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/22/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    let placeNameLabel = UILabel()
    let areaNameLabel = UILabel()
    let cityCountryNameLabel = UILabel()

    var constraintAdded = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.white

        placeNameLabel.text = "United Hospital"
        placeNameLabel.font = UIFont(name: "OpenSans-semibold", size: 18)
        placeNameLabel.textAlignment = .left
        placeNameLabel.textColor = UIColor.black
        placeNameLabel.lineBreakMode = .byWordWrapping
        placeNameLabel.numberOfLines = 0
        
        areaNameLabel.text = "Main Boulevard Gulberg"
        areaNameLabel.font = UIFont(name: "OpenSans", size: 15)
        areaNameLabel.textAlignment = .left
        areaNameLabel.textColor = Global.colorGray
        areaNameLabel.lineBreakMode = .byWordWrapping
        areaNameLabel.numberOfLines = 0
        
        cityCountryNameLabel.text = "Lahore, Pakistan"
        cityCountryNameLabel.font = UIFont(name: "OpenSans", size: 15)
        cityCountryNameLabel.textAlignment = .left
        cityCountryNameLabel.textColor = Global.colorGray
        cityCountryNameLabel.lineBreakMode = .byWordWrapping
        cityCountryNameLabel.numberOfLines = 0
        
        addSubview(placeNameLabel)
        addSubview(areaNameLabel)
        addSubview(cityCountryNameLabel)        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true
            
            placeNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            placeNameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            placeNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)

            areaNameLabel.autoPinEdge(.top, to: .bottom, of: placeNameLabel, withOffset: 2)
            areaNameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            areaNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)

            cityCountryNameLabel.autoPinEdge(.top, to: .bottom, of: areaNameLabel, withOffset: 2)
            cityCountryNameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            cityCountryNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            cityCountryNameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        }
    }
    
    var location: Location! {
        didSet {
            placeNameLabel.text = location.location
            areaNameLabel.text = location.desc
            cityCountryNameLabel.text = location.fullAddress
        }
    }
}
