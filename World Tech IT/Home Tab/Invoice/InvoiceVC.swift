//
//  InvoiceVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 20/01/21.
//

import UIKit
import SVProgressHUD
import Network

class InvoiceVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    @IBOutlet weak var filterLbl: UILabel!
    
    @IBOutlet weak var numberBackView: UIView!
    @IBOutlet weak var invoiceNumberLbl: UILabel!
    
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterView: UIView!
    
    private let spacing:CGFloat = 15.0
    let token = UserDefaults.standard.string(forKey: "ACCESS_TOKEN")

    var invoice: Invoice?
    var invoiceData: [InvoiceData] = []
    
    var searchText: String? = nil {
        didSet {
            searchTf?.text = searchText
        }
    }

    var filterShops: [InvoiceData] {
        
        if searchTf.text == "" {
            return invoiceData
        } else {
            return invoiceData.filter {
                $0.customer_name?.localizedCaseInsensitiveContains(searchTf.text ?? "") ?? false
            }
        }
        
    }
    
    @IBAction func filterCollectionView(_ sender: Any) {
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mobileNetwork()
        filterView.isHidden = true
        filterLbl.isHidden = true
//        addBtn.isHidden = true
        searchBackView.isHidden = true
        searchBackView.layer.borderColor = UIColor.lightGray.cgColor
        searchBackView.layer.borderWidth = 1
        searchTf.delegate = self
        
        getData()
        collectionView.isHidden = true
        SVProgressHUD.show()
        filterView.layer.borderColor = UIColor.lightGray.cgColor
        filterView.layer.borderWidth = 1
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            self.collectionView?.collectionViewLayout = layout
        
//        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getData()
    }
    
    func getData()
    {
        if let url = URL(string: "http://wt.tradeguruweb.com/api/v1/getallinvoice"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    print(url)
                    do {
                        
                        let response = try JSONDecoder().decode(Invoice.self, from: data ?? Data())
                        print("\(response)")
                        if response.status == "true" || response.message == "invoice found" {
                            
                            // dispatch to main queue
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                self.collectionView.isHidden = false
                                // capture data
                                self.invoiceData = response.data
                                // reload tableView
                                self.collectionView.reloadSections(IndexSet(integer: 0))
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
    
    @IBAction func addInvoice(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateInvoiceVC") as! CreateInvoiceVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        searchBackView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filterShops.count > 0 {
            invoiceNumberLbl.text = String(filterShops.count)
            return filterShops.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvoiceCollectionViewCell", for: indexPath) as! InvoiceCollectionViewCell
        
        cell.backView.layer.borderColor = UIColor.lightGray.cgColor
        cell.backView.layer.borderWidth = 1
        cell.profileOmg.layer.borderColor = UIColor.lightGray.cgColor
        cell.profileOmg.layer.borderWidth = 1
        
        let invoicArr = filterShops[indexPath.row]
        
        cell.nameLbl.text = invoicArr.customer_name ?? ""
        cell.invoiceDateLbl.text = invoicArr.invoice_date ?? ""
        cell.totalAmtLbl.text = invoicArr.total_amount ?? ""
        cell.AmtWordsLbl.text = invoicArr.amount_word ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AfterInvoiceVC") as! AfterInvoiceVC
        let invoicArr = filterShops[indexPath.row]
        
        vc.name = invoicArr.customer_name ?? ""
        vc.invoiceDate = invoicArr.invoice_date ?? ""
        vc.totalAmt = invoicArr.total_amount ?? ""
        vc.amtWord = invoicArr.amount_word ?? ""
        vc.itemName = invoicArr.item_detail ?? ""
        vc.qtny = invoicArr.qty ?? ""
        if invoicArr.invoice_id?.count == 1 {
            vc.invoice_id = "000\(invoicArr.invoice_id ?? "")"
        }
        if invoicArr.invoice_id?.count == 2 {
            vc.invoice_id = "00\(invoicArr.invoice_id ?? "")"
        }
        if invoicArr.invoice_id?.count == 3 {
            vc.invoice_id = "0\(invoicArr.invoice_id ?? "")"
        }
        if invoicArr.invoice_id?.count == 4 {
            vc.invoice_id = "\(invoicArr.invoice_id ?? "")"
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 15
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.collectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: 250)
            }else{
                return CGSize(width: 0, height: 250)
            }
        }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTf.resignFirstResponder()
        searchBackView.isHidden = true
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
    
}
