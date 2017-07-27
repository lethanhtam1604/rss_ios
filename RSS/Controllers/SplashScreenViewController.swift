//
//  SplashScreenViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 2/14/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Firebase

class SplashScreenViewController: UIViewController {
    
    let iconImgView = UIImageView()
    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        iconImgView.image = UIImage(named: "Group")
        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFit
        
        var isCheck = false
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if !isCheck {
                isCheck = true
                if user != nil {
                    self.navToMainPage()
                }
                else {
                    self.navToSignInPage()
                }
            }
        }
        
        view.addSubview(iconImgView)
        view.setNeedsUpdateConstraints()
    }
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            iconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            iconImgView.autoAlignAxis(toSuperviewAxis: .vertical)
            iconImgView.autoSetDimensions(to: CGSize(width: 200, height: 60))
        }
    }
    
    func navToSignInPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = SignInViewController()
        }
    }
    
    func navToMainPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = MainViewController()
        }
    }
}
