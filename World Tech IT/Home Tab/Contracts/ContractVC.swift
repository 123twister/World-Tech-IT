//
//  ContractVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 19/01/21.
//

import UIKit
import SVProgressHUD
import Network

class ContractVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var backView: UIView!
    //MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTf: UITextField!
    
    @IBAction func filterView(_ sender: UITextField) {
        tableView.reloadData()
    }
    
    
    //MARK:- PROPERTY
    
    let user_id = UserDefaults.standard.string(forKey: "ID")
    let token = UserDefaults.standard.string(forKey: "ACCESS_TOKEN")
    
    var contract: Contract?
    var contractData: [ContractData] = []
    
    var searchText: String? = nil {
        didSet {
            searchTf?.text = searchText
        }
    }

    var filterShops: [ContractData] {

        if searchTf.text == "" {
            return contractData
        } else {
            return contractData.filter {
                $0.contract_desc?.localizedCaseInsensitiveContains(searchTf.text ?? "") ?? false
            }
        }

    }
    
    //MARK:- FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        tableView.isHidden = true
        backView.isHidden = true
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.borderWidth = 1
        searchTf.delegate = self
        mobileNetwork()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getData()
    }
    
    func getData()
    {
        if let url = URL(string: "http://worldtech.tradeguruweb.com/api/v1/getallcontract"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    print(url)
                    do {
                        
                        let response = try JSONDecoder().decode(Contract.self, from: data ?? Data())
                        
                        if response.status == "true" {
                            print("\(response)")
                            // dispatch to main queue
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                self.tableView.isHidden = false
                                // capture data
                                self.contractData = response.data
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnterpriseTableViewCell", for: indexPath) as! EnterpriseTableViewCell
        
        cell.profileImg.layer.borderColor = UIColor.lightGray.cgColor
        cell.profileImg.layer.borderWidth = 1
        
        let contractArray = filterShops[indexPath.row]
        
        cell.nameLbl.text = contractArray.contract_desc ?? ""
        cell.dateLbl.text = contractArray.start_date ?? ""
        
        let imgUrlString = "http://worldtech.tradeguruweb.com/\(contractArray.contract_img ?? "")"
        let imgUrl = URL(string: imgUrlString)
        cell.profileImg.downloaded(from: imgUrl!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AfterEnterpriseInvoiceVC") as! AfterEnterpriseInvoiceVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTf.resignFirstResponder()
        backView.isHidden = true
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
    
    @IBAction func searchBtn(_ sender: UIButton) {
        backView.isHidden = false
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
