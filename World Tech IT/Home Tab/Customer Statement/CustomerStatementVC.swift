//
//  CustomerStatementVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 20/01/21.
//

import UIKit
import SVProgressHUD
import Network

class CustomerStatementVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTf: UITextField!
    
    //MARK:- PROPERTIES
    
    let user_id = UserDefaults.standard.string(forKey: "ID")
    let token = UserDefaults.standard.string(forKey: "ACCESS_TOKEN")
    
    var customer: Customer?
    var customeData: [CustomerData] = []
    var text = ""
    
    
    var searchText: String? = nil {
        didSet {
            searchTf?.text = searchText
        }
    }
    
    var filterShops: [CustomerData] {
        
        if searchTf.text == "" {
            return customeData
        } else {
            return customeData.filter {
                $0.customer_name?.localizedCaseInsensitiveContains(searchTf.text ?? "") ?? false
            }
        }
        
    }
    
    @IBAction func filterTableView(_ sender: UITextField) {
        tableView.reloadData()
    }
    
    
    //MARK:- FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNetwork()
        searchTf.text = text
        searchTf.delegate = self
        
        tableView.isHidden = true
        SVProgressHUD.show()
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mobileNetwork()
        getData()
    }
    
    func getData()
    {
        if let url = URL(string: "http://worldtech.tradeguruweb.com/api/v1/getallcustomer"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    print(url)
                    do {
                        
                        let response = try JSONDecoder().decode(Customer.self, from: data ?? Data())
                        
                        if response.status == "true" || response.message == "customer found" {
                            print("\(response)")
                            // dispatch to main queue
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                self.tableView.isHidden = false
                                // capture data
                                self.customeData = response.data
                                // reload tableView
                                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                                print("API executed successfully!!! ✅ ")
                            }
                            
                        } else {
                            //
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterShops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerStatementTableViewCell", for: indexPath) as! CustomerStatementTableViewCell
        
        cell.profileImg.layer.borderColor = UIColor.lightGray.cgColor
        cell.profileImg.layer.borderWidth = 1
        
        let customerArray = filterShops[indexPath.row]
        
        cell.nameLbl.text = customerArray.customer_name ?? ""
        UserDefaults.standard.setValue(String(customerArray.id ?? 0), forKey: "CONTRACTID")
        cell.dateLbl.text = "12-02-2021"
        cell.timeLbl.text = "12:03"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvoiceSummaryVC") as! InvoiceSummaryVC
        let customerArray = filterShops[indexPath.row]
        
        vc.contract_id = String(customerArray.id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTf.resignFirstResponder()
        return true
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
    
    //MARK:- ACTION
    @available(iOS 13.0, *)
    @IBAction func createBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "CreateCustomerVC") as! CreateCustomerVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
