//
//  InvoiceSummaryVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 20/01/21.
//

import UIKit
import SVProgressHUD
import SimplePDF
import Network

class InvoiceSummaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var totalInvoiceAmt: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var customeIdLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var totalPaidLbl: UILabel!
    @IBOutlet weak var balanceAmtLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UIView!
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var contract_id = ""
    var invoicePayment: InvoicePayment?
    var invoicePaymentDatum: [InvoicePaymentDatum]?
    var invoicePaymentData: [InvoicePaymentData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getCustomerData()
        mobileNetwork()
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
//        pdfDataWithTableView(tableView: tableView)
        
        let ss = self.view.takeScreenshot()
        self.createPDFDataFromImage(image: ss)
        
    }
    func createPDFDataFromImage(image: UIImage) {
        
        let pdfData = NSMutableData()
        let imgView = UIImageView.init(image: image)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
        UIGraphicsBeginPDFPage()
        let context = UIGraphicsGetCurrentContext()
        imgView.layer.render(in: context!)
        UIGraphicsEndPDFContext()

        //try saving in doc dir to confirm:
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let path = dir?.appendingPathComponent("file.pdf")

        do {
                try pdfData.write(to: path!, options: NSData.WritingOptions.atomic)
        } catch {
            print("error catched")
        }

        let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
        
    }
    func pdfDataWithTableView(tableView: UITableView) {
         let priorBounds = tableView.bounds
         let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.size.width, height:tableView.contentSize.height))
         tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
         let pdfPageBounds = CGRect(x:0, y:0, width:tableView.frame.width, height:self.view.frame.height)
         let pdfData = NSMutableData()
         UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds,nil)
         var pageOriginY: CGFloat = 0
         while pageOriginY < fittedSize.height {
             UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
             UIGraphicsGetCurrentContext()!.saveGState()
             UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
             tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
             UIGraphicsGetCurrentContext()!.restoreGState()
             pageOriginY += pdfPageBounds.size.height
         }
         UIGraphicsEndPDFContext()
         tableView.bounds = priorBounds
         var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
         docURL = docURL.appendingPathComponent("myDocument.pdf")
         pdfData.write(to: docURL as URL, atomically: true)
        print(docURL)
        
        let a4PaperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: a4PaperSize)
        let myFont = UIFont(name: "Candara-Bold", size: 20)
        let myFont1 = UIFont(name: "Candara", size: 18)
        let myNameFont = UIFont(name: "Candara-Bold", size: 25)
        pdf.setContentAlignment(.center)

        // add logo image
        let logoImage = #imageLiteral(resourceName: "WT logo")
        pdf.addImage(logoImage)

        pdf.addLineSpace(30)

        pdf.setContentAlignment(.left)
        pdf.addText("INVOICE TOTAL: \(totalInvoiceAmt.text ?? "")", font: myNameFont!)

        pdf.addLineSpace(20.0)

        pdf.addLineSeparator()

        pdf.addLineSpace(20.0)

        pdf.setContentAlignment(.left)
        pdf.addText("Customer Name", font: myFont!)
        pdf.addLineSpace(-10)
        pdf.setContentAlignment(.right)
        pdf.addText(dueDateLbl.text ?? "", font: myFont1!)

        pdf.addLineSpace(20.0)

        pdf.setContentAlignment(.left)
        pdf.addText("Total Paid", font: myFont!)
        pdf.addLineSpace(-10)
        pdf.setContentAlignment(.right)
        pdf.addText(totalPaidLbl.text ?? "", font: myFont1!)

        pdf.addLineSpace(20.0)

        pdf.addLineSeparator()

        pdf.addLineSpace(20.0)

        pdf.setContentAlignment(.left)
        pdf.addText("Balance Amount", font: myFont!)
        pdf.addLineSpace(-10)
        pdf.setContentAlignment(.right)
        pdf.addText(balanceAmtLbl.text ?? "", font: myFont1!)

        // Generate PDF data and save to a local file.
        let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

            let fileName = "Invoice.pdf"
            let documentsFileName = documentDirectories + "/" + fileName

            let pdfDataSimple = pdf.generatePDFdata()
            do{
                try pdfDataSimple.write(to: URL(fileURLWithPath: documentsFileName), options: .atomicWrite)

                print("\nThe generated pdf can be found at:")
                print("\n\t\(documentsFileName)\n")
            }catch{
                print(error)
            }
        
        let vc = UIActivityViewController(activityItems: [pdfData, pdfDataSimple], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
        
     }
    
    func getCustomerData()
    {
        if let url = URL(string: "http://wt.tradeguruweb.com/api/v1/showcontractbycustomerid/\(contract_id)"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    print(url)
                    do {

                        let response = try JSONDecoder().decode(InvoicePayment.self, from: data ?? Data())

                        if response.status == "true" {
                            print("\(response)")
                            // dispatch to main queue
                            SVProgressHUD.dismiss()
                            DispatchQueue.main.async {
                                self.tableView.isHidden = false
                                // capture data
                                self.invoicePaymentDatum = response.data
                                self.invoicePaymentData = response.payment
                                self.totalPaidLbl.text = "\(String(response.total_paid ?? 0)) KD"
                                self.balanceAmtLbl.text = "\(String(response.balanced_amount ?? 0)) KD"
                                self.totalInvoiceAmt.text = "\(String((response.total_paid ?? 0) + (response.balanced_amount ?? 0))) KD"
                                // reload tableView
                                self.tableView.reloadData()
//                                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                                print("API executed successfully!!! ✅ ")
                            }

                        }
                        
                        if response.status == "false" {
                            print("\(response)")
                            SVProgressHUD.dismiss()
                            self.tableView.isHidden = true
                        }
                        

                    }
                    catch{
                        print(error)
                    }
                }else
                {
                    print(error?.localizedDescription ?? "Data not found")
                }

            }.resume()

        }

    }


    @IBAction func backBtn(_ sender: Any) {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvoiceVC") as! InvoiceVC
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return invoicePaymentDatum?.count ?? 0
        case 1:
            return invoicePaymentData?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceSummaryCustomerTableViewCell", for: indexPath) as! InvoiceSummaryCustomerTableViewCell
            
            let arr = invoicePaymentDatum?[indexPath.row]
            cell.customerIdLbl.text = arr?.customer_id ?? ""
            cell.customerNameLbl.text = arr?.customer_name ?? ""
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceSummaryTableViewCell", for: indexPath) as! InvoiceSummaryTableViewCell
            
            let invoicePayArr = invoicePaymentData?[indexPath.row]
            cell.dateLbl.text = invoicePayArr?.invoice_date
            dueDateLbl.text = invoicePayArr?.invoice_date
            cell.amountLbl.text = "\(invoicePayArr?.amount ?? "") KD"
            cell.payMethodLbl.text = invoicePayArr?.payment_mode
            
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "InvoiceSummaryCustomerTableViewCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 85
        case 1:
            return 135
        default:
            return 0
        }
    }
    
    func mobileNetwork()
    {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    print("Connected")
                }
            } else {
                DispatchQueue.main.async {
                    self.displayAlertMessage(userMessage: "Please check the network")
                    SVProgressHUD.dismiss()
                }
            }
            
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension UIView {
    
    func takeScreenshot() -> UIImage {
    
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            return image!
        }
        
        return UIImage()
}
    

}
