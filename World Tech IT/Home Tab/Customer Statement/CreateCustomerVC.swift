//
//  CreateCustomerVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 03/03/21.
//

import UIKit
import SVProgressHUD

class CreateCustomerVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var customerNameTf: UITextField!
    @IBOutlet weak var companyTf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var mobileNumberTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customerView.layer.borderColor = UIColor.lightOrange.cgColor
        customerView.layer.borderWidth = 1
        
        emailView.layer.borderColor = UIColor.lightOrange.cgColor
        emailView.layer.borderWidth = 1
        
        mobileView.layer.borderColor = UIColor.lightOrange.cgColor
        mobileView.layer.borderWidth = 1
        
        companyView.layer.borderColor = UIColor.lightOrange.cgColor
        companyView.layer.borderWidth = 1
        
        addressView.layer.borderColor = UIColor.lightOrange.cgColor
        addressView.layer.borderWidth = 1
        
        customerNameTf.delegate = self
        emailTf.delegate = self
        mobileNumberTf.delegate = self
        companyTf.delegate = self
        addressTf.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        toolBar.items = [doneButton]
        toolBar.barTintColor = UIColor.white
        toolBar.isUserInteractionEnabled = true
        mobileNumberTf.inputAccessoryView = toolBar
        
    }
    
    
    @objc func donePicker()
    {
        mobileNumberTf.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        customerNameTf.resignFirstResponder()
        emailTf.resignFirstResponder()
        companyTf.resignFirstResponder()
        addressTf.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case mobileNumberTf:
            return range.location < 8
        default:
            return true
        }
    }
    
    func displayAlertMessage(userMessage: String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addCustomer()
    {
        SVProgressHUD.show()
        let name = customerNameTf.text
        let company = companyTf.text
        let email = emailTf.text
        let phone = mobileNumberTf.text
        let address = addressTf.text
        
        if (name == "") || (company == "") || (email == "") || (phone == "") || (address == "") {
            SVProgressHUD.dismiss()
            self.displayAlertMessage(userMessage: "Please enter all the details.")
        }
        else{
        if let url = URL(string: "http://wt.tradeguruweb.com/api/v1/addnewcustomer"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let params = [
                
                "customer_name": name ?? "",
                "company_name": company ?? "",
                "customer_email": email ?? "",
                "customer_contact": phone ?? "",
                "address": address ?? ""
                
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
                                let defaults = UserDefaults.standard
                                let user_id = json["user_id"]
                                let access_token = json["access_token"]
                                defaults.setValue(user_id, forKey: "ID")
                                defaults.setValue(access_token, forKey: "ACCESS_TOKEN")
                                
                                
                                defaults.synchronize()
                               
                                DispatchQueue.main.async {
                                    
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomerStatementVC") as! CustomerStatementVC
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

    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createBtn(_ sender: UIButton) {
        addCustomer()
    }
    
}
