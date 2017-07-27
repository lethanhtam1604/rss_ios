//
//  ReportViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/28/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import FontAwesomeKit
import MessageUI
import SwiftOverlays
import BNHtmlPdfKit

class ReportViewController: UIViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate {
    
    var constraintsAdded = false
    var currentIndex = 0
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let webView = UIWebView()
    
    var invoiceInfo: [String: AnyObject]!
    var invoiceComposer: InvoiceComposer!
    
    var HTMLContent: String!
    
    var job = Job()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.clipsToBounds = true
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = "REPORT"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        let iosUploadOutlineIcon = FAKIonIcons.iosUploadOutlineIcon(withSize: 30)
        iosUploadOutlineIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.black)
        let iosUploadOutlineImg  = iosUploadOutlineIcon?.image(with: CGSize(width: 40, height: 40))
        let shareBarButton = UIBarButtonItem(image: iosUploadOutlineImg, style: .done, target: self, action: #selector(share))
        shareBarButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = shareBarButton
        
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.backgroundColor = Global.colorBg
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        
        view.addSubview(webView)
        view.addSubview(indicator)
        view.setNeedsUpdateConstraints()
        
        loadData()
    }
    
    func loadData() {
        
        indicator.startAnimating()
        DatabaseHelper.shared.getUser(id: job.assign.staffId ?? "") {
            newStaff in
            if let staff = newStaff {
                
                self.invoiceComposer = InvoiceComposer()
                self.invoiceComposer.job = self.job
                self.invoiceComposer.staff = staff
                
                if let invoiceHTML = self.invoiceComposer.renderInvoice(isCreatePdf: true) {
                    self.webView.loadHTMLString(invoiceHTML, baseURL: NSURL(string: self.invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
                    self.HTMLContent = invoiceHTML
                    self.indicator.stopAnimating()
                }
            }
            else {
                self.indicator.stopAnimating()
            }
        }
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            webView.autoPinEdgesToSuperviewEdges()
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
    
    var html: String?
    
    func share() {
        SwiftOverlays.showBlockingWaitOverlay()
        DispatchQueue.main.async {
            self.invoiceComposer.exportHTMLContentToPDF(HTMLContent: self.HTMLContent!)
            SwiftOverlays.removeAllBlockingOverlays()
            self.sendEmail()
        }
    }
    


    func getDocDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }


    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Report")
            mail.addAttachmentData(NSData(contentsOfFile: invoiceComposer.pdfFilename)! as Data, mimeType: "application/pdf", fileName: "Report")
            mail.navigationBar.tintColor = Global.colorMain
            present(mail, animated: true, completion: nil)
        }
        else {
            Utils.showAlert(title: "Error", message: "You are not logged in email. Please check email configuration and try again", viewController: self)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
