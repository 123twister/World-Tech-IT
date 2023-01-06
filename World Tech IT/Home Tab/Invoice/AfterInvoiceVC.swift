//
//  AfterInvoiceVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 20/01/21.
//

import UIKit
import SimplePDF

class AfterInvoiceVC: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var invoiceDateLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var amtWordsLbl: UILabel!
    @IBOutlet weak var paidAmtLbl: UILabel!
    @IBOutlet weak var balanceAmtLbl: UILabel!
    @IBOutlet weak var invoiceNumberLbl: UILabel!
    
    @IBOutlet weak var removeView: UIStackView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet var pdfView: UIView!
    
    @IBOutlet weak var hashView: UIView!
    @IBOutlet weak var hashBackView: UIView!
    
    @IBOutlet weak var invoiceTotalView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var unitPriceView: UIView!
    @IBOutlet weak var totalPriceView: UIView!
    
    @IBOutlet weak var quantityBackView: UIView!
    @IBOutlet weak var unitPriceBackView: UIView!
    @IBOutlet weak var totalPriceBackView: UIView!
    
    @IBOutlet weak var totalView: UIView!
    
    @IBOutlet weak var invoiceId: UILabel!
    @IBOutlet weak var pdfDateLbl: UILabel!
    @IBOutlet weak var pdfNameLbl: UILabel!
    @IBOutlet weak var pdfItemLbl: UILabel!
    @IBOutlet weak var pdfQtnyLbl: UILabel!
    @IBOutlet weak var pdfUnitPriceLbl: UILabel!
    @IBOutlet weak var pdfTotalPriceLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var pdfAmountWordLbl: UILabel!
    
    
    var name = ""
    var invoiceDate = ""
    var totalAmt = ""
    var amtWord = ""
    var itemName = ""
    var qtny = ""
    var invoice_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        removeView.isHidden = true
        
        nameLbl.text = name
        invoiceDateLbl.text = invoiceDate
        totalAmtLbl.text = totalAmt
        amtWordsLbl.text = amtWord
        
        pdfNameLbl.text = name
        pdfDateLbl.text = invoiceDate
        pdfAmountWordLbl.text = amtWord
        pdfItemLbl.text = itemName
        pdfQtnyLbl.text = qtny
        pdfUnitPriceLbl.text = totalAmt
        pdfTotalPriceLbl.text = totalAmt
        totalPriceLbl.text = totalAmt
        invoiceId.text = invoice_id
        invoiceNumberLbl.text = "INVOICE \(invoice_id)"
        
        hashView.layer.borderColor = UIColor.darkGray.cgColor
        hashView.layer.borderWidth = 1
        
        hashBackView.layer.borderColor = UIColor.darkGray.cgColor
        hashBackView.layer.borderWidth = 1
        
        invoiceTotalView.layer.borderColor = UIColor.darkGray.cgColor
        invoiceTotalView.layer.borderWidth = 1
        
        descriptionView.layer.borderColor = UIColor.darkGray.cgColor
        descriptionView.layer.borderWidth = 1
        
        quantityView.layer.borderColor = UIColor.darkGray.cgColor
        quantityView.layer.borderWidth = 1
        
        unitPriceView.layer.borderColor = UIColor.darkGray.cgColor
        unitPriceView.layer.borderWidth = 1
        
        totalPriceView.layer.borderColor = UIColor.darkGray.cgColor
        totalPriceView.layer.borderWidth = 1
        
        quantityBackView.layer.borderColor = UIColor.darkGray.cgColor
        quantityBackView.layer.borderWidth = 1
        
        unitPriceBackView.layer.borderColor = UIColor.darkGray.cgColor
        unitPriceBackView.layer.borderWidth = 1
        
        totalPriceBackView.layer.borderColor = UIColor.darkGray.cgColor
        totalPriceBackView.layer.borderWidth = 1
        
        totalView.layer.borderColor = UIColor.darkGray.cgColor
        totalView.layer.borderWidth = 1
        
        profileImg.layer.borderColor = UIColor.lightGray.cgColor
        profileImg.layer.borderWidth = 1
        
        cancelBtn.layer.borderColor = UIColor.lightGray.cgColor
        cancelBtn.layer.borderWidth = 1
        
        sendBtn.layer.borderColor = UIColor.lightGray.cgColor
        sendBtn.layer.borderWidth = 1
        
    }
    
    func createPdfFromView(aView: UIView, saveToDocumentsWithFileName fileName: String)
    {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
        UIGraphicsBeginPDFPage()

        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }

        aView.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()

        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsFileName = documentDirectories + "/" + fileName
            debugPrint(documentsFileName)
            pdfData.write(toFile: documentsFileName, atomically: true)
        }
        let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendPdfBtn(_ sender: UIButton) {
        
        createPdfFromView(aView: pdfView, saveToDocumentsWithFileName: "Invoice.pdf")
        
//        let a4PaperSize = CGSize(width: 595, height: 842)
//        let pdf = SimplePDF(pageSize: a4PaperSize)
//        let myFont = UIFont(name: "Candara-Bold", size: 20)
//        let myFont1 = UIFont(name: "Candara", size: 18)
//        let myNameFont = UIFont(name: "Candara-Bold", size: 25)
//        pdf.setContentAlignment(.center)
//
//        // add logo image
//        let logoImage = #imageLiteral(resourceName: "WT logo")
//        pdf.addImage(logoImage)
//
//        pdf.addLineSpace(30)
//
//        pdf.setContentAlignment(.left)
//        pdf.addText("INVOICE NO. 0021", font: myNameFont!)
//
//        pdf.addLineSpace(20.0)
//
//        pdf.addLineSeparator()
//
//        pdf.addLineSpace(20.0)
//
//        pdf.setContentAlignment(.left)
//        pdf.addText("Customer Name", font: myFont!)
//        pdf.addLineSpace(-10)
//        pdf.setContentAlignment(.right)
//        pdf.addText(nameLbl.text ?? "", font: myFont1!)
//
//        pdf.addLineSpace(20.0)
//
//        pdf.setContentAlignment(.left)
//        pdf.addText("Invoice Date", font: myFont!)
//        pdf.addLineSpace(-10)
//        pdf.setContentAlignment(.right)
//        pdf.addText(invoiceDateLbl.text ?? "", font: myFont1!)
//
//        pdf.addLineSpace(20.0)
//
//        pdf.setContentAlignment(.left)
//        pdf.addText("Due date", font: myFont!)
//        pdf.addLineSpace(-10)
//        pdf.setContentAlignment(.right)
//        pdf.addText("20 Days", font: myFont1!)
//
//        pdf.addLineSpace(20.0)
//
//        pdf.setContentAlignment(.left)
//        pdf.addText("Total Amount", font: myFont!)
//        pdf.addLineSpace(-10)
//        pdf.setContentAlignment(.right)
//        pdf.addText(totalAmtLbl.text ?? "", font: myFont1!)
//
//        pdf.addLineSpace(20.0)
//
//        pdf.setContentAlignment(.left)
//        pdf.addText("Total Invoice in Words", font: myFont!)
//        pdf.addLineSpace(-10)
//        pdf.setContentAlignment(.right)
//        pdf.addText(amtWordsLbl.text ?? "", font: myFont1!)
//
//        pdf.addLineSpace(20.0)
//
//        pdf.setContentAlignment(.left)
//        pdf.addText("Paid Amount", font: myFont!)
//        pdf.addLineSpace(-10)
//        pdf.setContentAlignment(.right)
//        pdf.addText("10000 KD", font: myFont1!)
//
//        pdf.addLineSpace(20.0)
//
//        pdf.addLineSeparator()
//
//        pdf.addLineSpace(20.0)
//
//        pdf.setContentAlignment(.left)
//        pdf.addText("Balance Amount", font: myFont!)
//        pdf.addLineSpace(-10)
//        pdf.setContentAlignment(.right)
//        pdf.addText("5000 KD", font: myFont1!)
//
//        // Generate PDF data and save to a local file.
//        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
//
//            let fileName = "Invoice.pdf"
//            let documentsFileName = documentDirectories + "/" + fileName
//
//            let pdfData = pdf.generatePDFdata()
//            do{
//                try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomicWrite)
//                print("\nThe generated pdf can be found at:")
//                print("\n\t\(documentsFileName)\n")
//            }catch{
//                print(error)
//            }
//            let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
//            self.present(vc, animated: true, completion: nil)
//        }
    }
}
