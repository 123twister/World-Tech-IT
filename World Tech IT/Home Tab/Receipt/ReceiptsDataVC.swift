//
//  ReceiptsDataVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 20/01/21.
//

import UIKit
import SVProgressHUD
import SimplePDF
import Network

class ReceiptsDataVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
 
    
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var dateTf: UITextField!
    @IBOutlet var pdfView: UIView!
    @IBOutlet weak var RCTView: UIView!
    @IBOutlet weak var stackBackView: UIStackView!
    @IBOutlet weak var pdfDateLbl: UILabel!
    @IBOutlet weak var pdfNameLbl: UILabel!
    @IBOutlet weak var pdfSumLbl: UILabel!
    @IBOutlet weak var pdfBankLbl: UILabel!
    @IBOutlet weak var pdfCashLbl: UILabel!
    @IBOutlet weak var pdfAmountLbl: UILabel!
    @IBOutlet weak var pdfKDLbl: UILabel!
    @IBOutlet weak var pdfFillsLbl: UILabel!
    @IBOutlet weak var pdfRCTLbl: UILabel!
    
    @IBAction func dateEdit(_ sender: Any) {
        if dateTf.text == "" {
            getData()
            tableView.reloadData()
        }
        else
        {
            getSpecificData()
            tableView.reloadData()
        }
    }
    var receipts: Receipts?
    var receiptsData: [ReceiptsData] = []
    
    var searchText: String? = nil {
        didSet {
            searchTf?.text = searchText
        }
    }
    
    var filterShops: [ReceiptsData] {
        
        if searchTf.text == "" {
            return receiptsData
        } else {
            return receiptsData.filter {
                $0.customer_name?.localizedCaseInsensitiveContains(searchTf.text ?? "") ?? false
            }
        }
        
    }
    @IBAction func filterView(_ sender: UITextField) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RCTView.layer.borderColor = UIColor.yellow.cgColor
        RCTView.layer.borderWidth = 1
        
        stackBackView.layer.borderColor = UIColor.darkGray.cgColor
        stackBackView.layer.borderWidth = 1
        
        mobileNetwork()
        filterView.isHidden = true
        tableView.isHidden = true
        SVProgressHUD.show()
        dateTf.delegate = self
        searchTf.delegate = self
        
        filterView.layer.borderColor = UIColor.lightGray.cgColor
        filterView.layer.borderWidth = 1
        
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
        dateTf.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        // Do any additional setup after loading the view.
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.dateTf.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateTf.text = dateFormatter.string(from: datePicker.date)
        }
        getSpecificData()
        tableView.reloadData()
        self.dateTf.resignFirstResponder()
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
    
    @IBAction func addNewBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
        
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func getData()
    {
      
            if let url = URL(string: "http://wt.tradeguruweb.com/api/v1/payment/all"){
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //            request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
                
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if error == nil{
                        print(url)
                        do {
                            
                            let response = try JSONDecoder().decode(Receipts.self, from: data ?? Data())
                            
                            if response.status == "true" {
                                print("\(response)")
                                // dispatch to main queue
                                DispatchQueue.main.async {
                                    SVProgressHUD.dismiss()
                                    self.tableView.isHidden = false
                                    // capture data
                                    self.receiptsData = response.data
                                    // reload tableView
                                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                                    print("API executed successfully!!! ✅ ")
                                }
                                
                            } else {
                                self.tableView.isHidden = true
                               SVProgressHUD.dismiss()
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
    
    func getSpecificData()
    {
      
            if let url = URL(string: "http://wt.tradeguruweb.com/api/v1/payment/all?filter_date=\(dateTf.text ?? "")"){
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //            request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
                
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if error == nil{
                        print(url)
                        do {
                            
                            let response = try JSONDecoder().decode(Receipts.self, from: data ?? Data())
                            
                            if response.status == "false" {
                                print("\(response)")
                                // dispatch to main queue
                                DispatchQueue.main.async {
                                    self.tableView.isHidden = true
                                   SVProgressHUD.dismiss()
                                }
                              
                                
                            } else {
                                DispatchQueue.main.async {
                                    SVProgressHUD.dismiss()
                                    self.tableView.isHidden = false
                                    // capture data
                                    self.receiptsData = response.data
                                    // reload tableView
                                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                                    print("API executed successfully!!! ✅ ")
                                }
                              
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterShops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptsTableViewCell", for: indexPath) as! ReceiptsTableViewCell
        
        cell.backView.layer.borderColor = UIColor.lightGray.cgColor
        cell.backView.layer.borderWidth = 1
        
        let receipArr = filterShops[indexPath.row]
        
        cell.nameLbl.text = receipArr.customer_name
        cell.receiptDateLbl.text = receipArr.receipt_date
        cell.receiptAmtLbl.text = "\(receipArr.receipt_amount ?? "") KD"
        cell.paymentMtdLbl.text = receipArr.receipt_method
        cell.chequeNumberLbl.text = receipArr.cheque_number
        cell.bankLbl.text = receipArr.bank
        
        cell.onSendReceipts = { [weak self] in
            
            self?.pdfNameLbl.text = receipArr.customer_name
            self?.pdfDateLbl.text = receipArr.receipt_date
            self?.pdfSumLbl.text = "\(receipArr.amount_word ?? "") Kuwaiti Dinar and 000 Fils only"
            self?.pdfKDLbl.text = receipArr.receipt_amount
            self?.pdfFillsLbl.text = "000"
            if receipArr.bank == nil {
                self?.pdfBankLbl.text = "-----"
            } else {
                self?.pdfBankLbl.text = receipArr.bank
            }
            if receipArr.receipt_method == "Bank" {
                self?.pdfCashLbl.text = "-----"
            } else {
                self?.pdfCashLbl.text = receipArr.cheque_number
            }
            self?.pdfAmountLbl.text = "Payment for Invoice Number \(receipArr.invoice_id ?? "")"
            
            if receipArr.id?.count == 1 {
                self?.pdfRCTLbl.text = "RCT-0000\(receipArr.id ?? "0")"
            }
            
            if receipArr.id?.count == 2 {
                self?.pdfRCTLbl.text = "RCT-000\(receipArr.id ?? "0")"
            }
            
            if receipArr.id?.count == 3 {
                self?.pdfRCTLbl.text = "RCT-00\(receipArr.id ?? "0")"
            }
            
            if receipArr.id?.count == 4 {
                self?.pdfRCTLbl.text = "RCT-0\(receipArr.id ?? "0")"
            }
            
            if receipArr.id?.count == 5 {
                self?.pdfRCTLbl.text = "RCT-\(receipArr.id ?? "0")"
            }
            
            self?.createPdfFromView(aView: (self?.pdfView)!, saveToDocumentsWithFileName: "Receipt.pdf")
//            let a4PaperSize = CGSize(width: 595, height: 842)
//            let pdf = SimplePDF(pageSize: a4PaperSize)
//            let myFont = UIFont(name: "Candara-Bold", size: 20)
//            let myFont1 = UIFont(name: "Candara", size: 18)
//            let myNameFont = UIFont(name: "Candara-Bold", size: 25)
//            pdf.setContentAlignment(.center)
//
//            // add logo image
//            let logoImage = #imageLiteral(resourceName: "WT logo")
//            pdf.addImage(logoImage)
//
//            pdf.addLineSpace(30)
//
//            pdf.setContentAlignment(.center)
//            pdf.addText("\(receipArr.customer_name ?? "")".uppercased(), font: myNameFont!)
//
//            pdf.addLineSpace(20.0)
//
//            pdf.setContentAlignment(.left)
//            pdf.addText("Receipt Date", font: myFont!)
//            pdf.addLineSpace(-10)
//            pdf.setContentAlignment(.right)
//            pdf.addText("\(receipArr.receipt_date ?? "")", font: myFont1!)
//
//            pdf.addLineSpace(20.0)
//
//            pdf.setContentAlignment(.left)
//            pdf.addText("Receipt Amount", font: myFont!)
//            pdf.addLineSpace(-10)
//            pdf.setContentAlignment(.right)
//            pdf.addText("\(receipArr.receipt_amount ?? "") KD", font: myFont1!)
//
//            pdf.addLineSpace(20.0)
//
//            pdf.setContentAlignment(.left)
//            pdf.addText("Payment Method", font: myFont!)
//            pdf.addLineSpace(-10)
//            pdf.setContentAlignment(.right)
//            pdf.addText("\(receipArr.receipt_method ?? "")", font: myFont1!)
//
//            pdf.addLineSpace(20.0)
//
//            pdf.setContentAlignment(.left)
//            pdf.addText("Cheque Number", font: myFont!)
//            pdf.addLineSpace(-10)
//            pdf.setContentAlignment(.right)
//            pdf.addText("\(receipArr.cheque_number ?? "")", font: myFont1!)
//
//            pdf.addLineSpace(20.0)
//
//            pdf.setContentAlignment(.left)
//            pdf.addText("Bank", font: myFont!)
//            pdf.addLineSpace(-10)
//            pdf.setContentAlignment(.right)
//            pdf.addText("\(receipArr.bank ?? "")", font: myFont1!)
//
//            pdf.addLineSpace(20.0)
//
//            pdf.addLineSeparator()
//
//            pdf.addLineSpace(20.0)
//
//            pdf.setContentAlignment(.left)
//            pdf.addText("Due", font: myFont!)
//            pdf.addLineSpace(-10)
//            pdf.setContentAlignment(.right)
//            pdf.addText("\(receipArr.receipt_amount ?? "") KD", font: myFont1!)
//
//            // Generate PDF data and save to a local file.
//            if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
//
//                let fileName = "Receipt.pdf"
//                let documentsFileName = documentDirectories + "/" + fileName
//
//                let pdfData = pdf.generatePDFdata()
//                do{
//                    try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomicWrite)
//                    print("\nThe generated pdf can be found at:")
//                    print("\n\t\(documentsFileName)\n")
//                }catch{
//                    print(error)
//                }
//                let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
//                self?.present(vc, animated: true, completion: nil)
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 385
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTf.resignFirstResponder()
        return true
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//      if dateTf.text!.isEmpty {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
//        dateTf.text = formatter.string(from: Date())
//      }
//      return true
//    }
//
}

extension UITextField {

   func addInputViewDatePicker(target: Any, selector: Selector) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    datePicker.datePickerMode = .date
    self.inputView = datePicker

    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }

   @objc func cancelPressed() {
     self.resignFirstResponder()
   }
}
