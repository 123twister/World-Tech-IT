//
//  CreateInvoiceVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 20/01/21.
//

import UIKit
import SVProgressHUD

class CreateInvoiceVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var customerNameView: UIView!
    @IBOutlet weak var projectNameView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var totalAmtView: UIView!
    
    @IBOutlet weak var customerNameTf: UITextField!
    @IBOutlet weak var projectNameTf: UITextField!
    @IBOutlet weak var dateTf: UITextField!
    @IBOutlet weak var endDateTf: UITextField!
    @IBOutlet weak var totalAmtTf: UITextField!
    
    @IBOutlet weak var customerIdLbl: UILabel!
    
    var customer: Customer?
    var customeData: [CustomerData]?
    
    var customerName = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        customerNameTf.inputView = customerName
        customerName.delegate = self
        customerName.dataSource = self
        customerNameTf.delegate = self
        
        totalAmtTf.delegate = self
        endDateTf.delegate = self
        dateTf.delegate = self
        
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
        totalAmtTf.inputAccessoryView = toolBar
        
        customerNameView.layer.borderColor = UIColor.lightOrange.cgColor
        customerNameView.layer.borderWidth = 1
        
        dateView.layer.borderColor = UIColor.lightOrange.cgColor
        dateView.layer.borderWidth = 1
        
        totalAmtView.layer.borderColor = UIColor.lightOrange.cgColor
        totalAmtView.layer.borderWidth = 1
        
        projectNameView.layer.borderColor = UIColor.lightOrange.cgColor
        projectNameView.layer.borderWidth = 1
        
        endDateView.layer.borderColor = UIColor.lightOrange.cgColor
        endDateView.layer.borderWidth = 1
        
        getUnitData()
        endDateTf.addInputViewDatePicker(target: self, selector: #selector(endDoneButtonPressed))
        dateTf.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUnitData()
    }
    
    @objc func donePicker()
    {
        customerNameTf.resignFirstResponder()
        totalAmtTf.resignFirstResponder()
        
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
    
    @objc func endDoneButtonPressed() {
        if let  datePicker = self.endDateTf.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.endDateTf.text = dateFormatter.string(from: datePicker.date)
        }
        self.endDateTf.resignFirstResponder()
     }
    
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createInvoice() {
        
        SVProgressHUD.setStatus("Submitting...")
        
        let customer = customerNameTf.text
        let project = projectNameTf.text
        let startDate = dateTf.text
        let endDate = endDateTf.text
        let amount = totalAmtTf.text
        
        if (customer == "") || (project == "") || (startDate == "") || (endDate == "") || (amount == "") {
            SVProgressHUD.dismiss()
        } else {
            if let url = URL(string: "http://wt.tradeguruweb.com/api/v1/createcontract"){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
//                contract_img
//                customer_id
//                seles_price
//                start_date
//                end_date
//                contract_desc
//                contract_notes
                
                let params = [
                    
                    "contract_img": "",
                    "customer_id": customerIdLbl.text ?? "",
                    "seles_price": amount ?? "",
                    "start_date": startDate ?? "",
                    "end_date": endDate ?? "",
                    "contract_desc": customer ?? "",
                    "contract_notes": project ?? ""
                    
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
                            print(json)
                            if let success = json["status"]{
                                if success as! String == "false"
                                {
                                    print(json)
                                    SVProgressHUD.dismiss()
                                    DispatchQueue.main.async
                                    {
                                        self.displayAlertMessage(userMessage:"Something went wrong!")
                                    }
                                }else
                                
                                {
                                    print(json)
                                    SVProgressHUD.dismiss()
                                    DispatchQueue.main.async {
                                        
                                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvoiceVC") as! InvoiceVC
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customeData?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        customeData?[row].customer_name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        customerNameTf.text = customeData?[row].customer_name
        customerIdLbl.text = String(customeData?[row].id ?? 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        totalAmtTf.resignFirstResponder()
        return true
    }
    
    @IBAction func generateInvoiceBtn(_ sender: Any) {
        
        createInvoice()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
