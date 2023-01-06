//
//  ReceiptVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 19/01/21.
//

import UIKit
import Network
import SVProgressHUD

class ReceiptVC: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var customerNameView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var receiptView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var chequeView: UIView!
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var invoiceView: UIView!
    
    @IBOutlet weak var chequeDownImage: UIImageView!
    @IBOutlet weak var customerNameTf: UITextField!
    @IBOutlet weak var dateTf: UITextField!
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var payMethodTf: UITextField!
    @IBOutlet weak var chequeNumberTf: UITextField!
    @IBOutlet weak var bankTf: UITextField!
    @IBOutlet weak var invoiceSelectionTf: UITextField!
    
    @IBOutlet weak var contractIdLbl: UILabel!
    @IBOutlet weak var customerIdLbl: UILabel!
    
    var customer: Customer?
    var customeData: [CustomerData]?
    
    var contract: Contract?
    var contractData: [ContractData]?
    
    var customerName = UIPickerView()
    var cheque = UIPickerView()
    var invoicName = UIPickerView()
    
    var chequeDetails = ["Bank", "Cash", "Cheque"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chequeView.isHidden = true
        bankView.isHidden = true
    
        chequeDownImage.isHidden = true
        
        customerNameTf.inputView = customerName
        customerName.delegate = self
        customerName.dataSource = self
        
        payMethodTf.inputView = cheque
        cheque.delegate = self
        cheque.dataSource = self
        
        invoiceSelectionTf.inputView = invoicName
        invoicName.delegate = self
        invoicName.dataSource = self
        
        customerName.tag = 1
        cheque.tag = 2
        invoicName.tag = 3
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        toolBar.items = [doneButton]
        toolBar.barTintColor = UIColor.white
        toolBar.isUserInteractionEnabled = true
        customerNameTf.inputAccessoryView = toolBar
        payMethodTf.inputAccessoryView = toolBar
        invoiceSelectionTf.inputAccessoryView = toolBar
        amountTf.inputAccessoryView = toolBar
        
        customerNameTf.delegate = self
        dateTf.delegate = self
        amountTf.delegate = self
        payMethodTf.delegate = self
        chequeNumberTf.delegate = self
        bankTf.delegate = self
        invoiceSelectionTf.delegate = self
        
        customerNameView.layer.borderColor = UIColor.lightOrange.cgColor
        customerNameView.layer.borderWidth = 1
        
        dateView.layer.borderColor = UIColor.lightOrange.cgColor
        dateView.layer.borderWidth = 1
        
        receiptView.layer.borderColor = UIColor.lightOrange.cgColor
        receiptView.layer.borderWidth = 1
        
        paymentView.layer.borderColor = UIColor.lightOrange.cgColor
        paymentView.layer.borderWidth = 1
        
        chequeView.layer.borderColor = UIColor.lightOrange.cgColor
        chequeView.layer.borderWidth = 1
        
        bankView.layer.borderColor = UIColor.lightOrange.cgColor
        bankView.layer.borderWidth = 1
        
        invoiceView.layer.borderColor = UIColor.lightOrange.cgColor
        invoiceView.layer.borderWidth = 1
        getUnitData()
        
        dateTf.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.dateTf.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateTf.text = dateFormatter.string(from: datePicker.date)
        }
        self.dateTf.resignFirstResponder()
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUnitData()
        getInvoiceData()
    }
    
    @objc func donePicker()
    {
        if payMethodTf.text == "Bank" {
            chequeView.isHidden = true
            bankView.isHidden = false
        }
        if payMethodTf.text == "Cheque" {
            chequeView.isHidden = false
            bankView.isHidden = true
        }
        if payMethodTf.text == "Cash" {
            chequeView.isHidden = true
            bankView.isHidden = true
        }
        
        if customerNameTf.text == "sandeep" {
            amountTf.text = "900"
        } else {
            amountTf.text = "0"
        }
        
        customerNameTf.resignFirstResponder()
        payMethodTf.resignFirstResponder()
        invoiceSelectionTf.resignFirstResponder()
        amountTf.resignFirstResponder()
    }
    
    func getUnitData()
    {
        if let url = URL(string: "http://wt.tradeguruweb.com/api/v1/getallcustomer"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("Bearer \(access_token ?? "")", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    do {
                        
                        let response = try JSONDecoder().decode(Customer.self, from: data ?? Data())
                        
                        if response.status == "true" {
                            
                            // dispatch to main queue
                            DispatchQueue.main.async {
                                
                                // capture data
                                self.customeData = response.data
                                // reload tableView
                                self.customerName.reloadComponent(0)
                                
                            }
                            
                        } else {
                            // Show error to user view Alert Controller
                        }
                        
                    }
                    catch{
                        
                        print(error)
                        
                    }
                }else
                {
                    print(error?.localizedDescription ?? "")
                }
                
            }.resume()
            
        }
        
    }
    
    func getInvoiceData()
    {
        if let url = URL(string: "http://wt.tradeguruweb.com/api/v1/getallcontract"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("Bearer \(access_token ?? "")", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    do {
                        
                        let response = try JSONDecoder().decode(Contract.self, from: data ?? Data())
                        
                        if response.status == "true" {
                            
                            // dispatch to main queue
                            DispatchQueue.main.async {
                                
                                // capture data
                                self.contractData = response.data
                                // reload tableView
                                self.invoicName.reloadComponent(0)
                                
                            }
                            
                        } else {
                            // Show error to user view Alert Controller
                        }
                        
                    }
                    catch{
                        
                        print(error)
                        
                    }
                }else
                {
                    print(error?.localizedDescription ?? "")
                }
                
            }.resume()
            
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            return customeData?.count ?? 0
        case 2:
            return chequeDetails.count
        case 3:
            return contractData?.count ?? 0
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return customeData?[row].customer_name
        case 2:
            return chequeDetails[row]
        case 3:
            return contractData?[row].contract_desc
        default:
            return "Data not found."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            customerNameTf.text = customeData?[row].customer_name
            customerIdLbl.text = String(customeData?[row].id ?? 1)
        case 2:
            payMethodTf.text = chequeDetails[row]
        case 3:
            invoiceSelectionTf.text = contractData?[row].contract_desc
            contractIdLbl.text = String(contractData?[row].id ?? 1)
        default:
            return
        }
    }
    
    
    @IBAction func createBtn(_ sender: Any) {
        addReceipt()
    }
    
    func addReceipt()
    {
        SVProgressHUD.show()
        let name = customerNameTf.text
        let date = dateTf.text
        let amount = amountTf.text
        let method = payMethodTf.text
        let cheque = chequeNumberTf.text
        let bank = bankTf.text
        let invoice = invoiceSelectionTf.text
        
        if (name == "") || (date == "") || (amount == "") || (method == "") || (invoice == "") {
            SVProgressHUD.dismiss()
            self.displayAlertMessage(userMessage: "Please enter all the details.")
        }
        else{
        if let url = URL(string: "http://wt.tradeguruweb.com/api/v1/payment/create"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
//            contract_id
//            paid_amount
//            payment_date
//            payment_mode
//            cheque_number
//            bank
//            payment_desc
//            payment_notes
//            payment_img  in base64
            let params = [
                
                "contract_id": contractIdLbl.text ?? "",
                "customer_id": customerIdLbl.text ?? "",
                "paid_amount": amount ?? "",
                "payment_date": date ?? "",
                "payment_mode": method ?? "",
                "cheque_number": cheque ?? "",
                "bank": bank ?? "",
                "payment_desc": "",
                "payment_notes": ""
                
            ]
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                return
                
            }
            request.httpBody = httpBody
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    print(url)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        if let success = json["status"]{
                            if success as! String == "false"
                            {
                                SVProgressHUD.dismiss()
                                DispatchQueue.main.async
                                {
                                    self.displayAlertMessage(userMessage:"Something went wrong!")
                                }
                            }else
                            
                            {
                                SVProgressHUD.dismiss()
                                let defaults = UserDefaults.standard
                                let user_id = json["user_id"]
                                let access_token = json["access_token"]
                                defaults.setValue(user_id, forKey: "ID")
                                defaults.setValue(access_token, forKey: "ACCESS_TOKEN")
                                
                                
                                defaults.synchronize()
                               
                                DispatchQueue.main.async {
                                    
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReceiptsDataVC") as! ReceiptsDataVC
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    self.displayAlertMessage(userMessage: "Successfully created!")
                                }

                            }
                        }
                    }
                    catch{
                        
                    }
                }else
                {
                    print(error?.localizedDescription ?? "Data not found")
                }
                
            }.resume()
        }
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
        customerNameTf.resignFirstResponder()
        dateTf.resignFirstResponder()
        amountTf.resignFirstResponder()
        payMethodTf.resignFirstResponder()
        chequeNumberTf.resignFirstResponder()
        bankTf.resignFirstResponder()
        invoiceSelectionTf.resignFirstResponder()
        
        return true
    }

}
