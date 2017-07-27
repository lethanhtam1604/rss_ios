//
//  InvoiceComposer.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 23/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class InvoiceComposer: NSObject {
    
    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "invoice", ofType: "html")
    
    let pathToPartItemHTMLTemplate = Bundle.main.path(forResource: "part_item", ofType: "html")
    
    let pathToPhotoItemHTMLTemplate = Bundle.main.path(forResource: "photo_item", ofType: "html")
    
    let pathToPhotoURLItemHTMLTemplate = Bundle.main.path(forResource: "photo_url_item", ofType: "html")
    
    let logoImageURL = "https://firebasestorage.googleapis.com/v0/b/retail-security-solution.appspot.com/o/Group%403x.png?alt=media&token=0245347e-64f6-4ef7-a2ce-45f2248009a1"
    
    var invoiceNumber: String!
    
    var pdfFilename: String!
    
    var job = Job()
    
    var staff = User()
    
    override init() {
        super.init()
    }
    
    
    func renderInvoice(isCreatePdf: Bool) -> String! {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let reportDate = dateFormatter.string(from: date)
        
        do {
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: convertImageUrlToBase64(path: logoImageURL))
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#REPORT_DATE#", with: reportDate)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#CLIENT_NAME#", with: job.clientName ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ADDRESS#", with: job.location.fullAddress ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#CONTACT_NAME#", with: job.contacts[0].jobContact ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#EMAIL#", with: job.contacts[0].email ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PHONE#", with: job.contacts[0].phone ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#MOBILE#", with: job.contacts[0].mobile ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#JOB_DESCRIPTION#", with: job.jobDescription ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#JOB_LOCATION#", with: job.location.fullAddress ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#STAFF_NAME#", with: staff.name ?? "")
            
            var minutes = Int(job.arrivedTime!) / 60 % 60
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TIME_ARRIVED#", with: String(minutes))
            
            minutes = Int(job.checkoutTime!) / 60 % 60
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#END_TIME#", with: String(minutes))
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#JOB_SUMMARY#", with: job.checkList.summary ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#NARRATIVE_OF_REPAIR#", with: job.checkList.narrativeOfRepairs ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#FOLLOW_UP_REQUIRED#", with: job.checkList.followUpRequired! ? "YES" : "NO")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PART_NEEDED#", with: job.checkList.partNeeded! ? "YES" : "NO")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#EXPENSE_SUMMARY#", with: job.expenses.descriptionExpenses ?? "")
            
            var allItems = ""
            
            for part in job.checkList.parts {
                
                var itemHTMLContent: String!
                
                itemHTMLContent = try String(contentsOfFile: pathToPartItemHTMLTemplate!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#TITLE#", with: part.name ?? "")
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#DESCRIPTION#", with: part.partDescription ?? "")
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#QUANTITY#", with: String(part.quantity!))
                
                allItems += itemHTMLContent
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PARTS#", with: allItems)
            
            allItems = ""
            
            for imageURL in job.checkList.photoBefore {
                
                var itemHTMLContent: String!
                
                if isCreatePdf {
                    itemHTMLContent = try String(contentsOfFile: pathToPhotoItemHTMLTemplate!)
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PHOTO#", with: convertImageUrlToBase64(path: imageURL.image ?? ""))
                }
                else {
                    itemHTMLContent = try String(contentsOfFile: pathToPhotoURLItemHTMLTemplate!)
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PHOTO#", with: imageURL.image ?? "")
                }
                
                allItems += itemHTMLContent
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PHOTO_BEFORE#", with: allItems)
            
            allItems = ""
            
            for imageURL in job.checkList.photoAfter {
                
                var itemHTMLContent: String!
                
                if isCreatePdf {
                    itemHTMLContent = try String(contentsOfFile: pathToPhotoItemHTMLTemplate!)
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PHOTO#", with: convertImageUrlToBase64(path: imageURL.image ?? ""))
                }
                else {
                    itemHTMLContent = try String(contentsOfFile: pathToPhotoURLItemHTMLTemplate!)
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PHOTO#", with: imageURL.image ?? "")
                }
                
                allItems += itemHTMLContent
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PHOTO_AFTER#", with: allItems)
            
            allItems = ""
            
            for imageURL in job.expenses.imageUrl {
                
                var itemHTMLContent: String!
                
                if isCreatePdf {
                    itemHTMLContent = try String(contentsOfFile: pathToPhotoItemHTMLTemplate!)
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PHOTO#", with: convertImageUrlToBase64(path: imageURL.image ?? ""))
                }
                else {
                    itemHTMLContent = try String(contentsOfFile: pathToPhotoURLItemHTMLTemplate!)
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PHOTO#", with: imageURL.image ?? "")
                }
                
                allItems += itemHTMLContent
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PHOTO_EXPENSE#", with: allItems)
            
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PHOTO_SIGNATURE#", with: convertImageUrlToBase64(path: job.checkList.signature ?? ""))
            
            return HTMLContent
            
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        pdfFilename = "\(getDocDir())/Report.pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
        
        print(pdfFilename)
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        for i in 1...printPageRenderer.numberOfPages {
            
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            printPageRenderer.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext()
        
        return data
    }
    
    let currencyCode = "eur"
    
    func getStringValueFormattedAsCurrency(value: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencyCode = currencyCode
        numberFormatter.maximumFractionDigits = 2
        
        let formattedValue = numberFormatter.string(from: NumberFormatter().number(from: value)!)
        return formattedValue!
    }
    
    
    func getDocDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func convertImageUrlToBase64(path: String) -> String {
        do {
            let imageData: NSData = try NSData.init(contentsOf: URL(string: path)!)
            let base64 = imageData.base64EncodedString(options: .lineLength64Characters)
            return base64
        }
        catch {
            return ""
        }
    }
}
