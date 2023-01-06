//
//  HomeViewController.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 08/01/21.
//

import UIKit
import Network

class HomeViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var viewClicked: UIView!
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var receiotView: UIView!
    @IBOutlet weak var invoiceView: UIView!
    @IBOutlet weak var generatedView: UIView!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var contractsView: UIView!
    @IBOutlet weak var receiptView: UIView!
    @IBOutlet weak var customerStatementView: UIView!
    
    @IBOutlet weak var invoiceClickedView: UIView!
    
    //MARK:- PROPERTIES
    
    var isSideViewOpen: Bool = false
    
    //MARK:- FUNCTION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNetwork()
        searchTf.delegate = self
        
        isSideViewOpen = false
        profileImgView.layer.borderColor = UIColor.darkGray.cgColor
        profileImgView.layer.borderWidth = 1
        
        let clickedView = UITapGestureRecognizer(target: self, action: #selector(self.handleViewClicked(sender:)))
        viewClicked.addGestureRecognizer(clickedView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        homeView.addGestureRecognizer(tap)
        
        let contractTap = UITapGestureRecognizer(target: self, action: #selector(self.handleContract(sender:)))
        contractsView.addGestureRecognizer(contractTap)
        
        let settingTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSetting(sender:)))
        settingView.addGestureRecognizer(settingTap)
        
        
        let receiptTap = UITapGestureRecognizer(target: self, action: #selector(self.handleReceipt(sender:)))
        //        customerView.addGestureRecognizer(receiptTap)
        receiptView.addGestureRecognizer(receiptTap)
        
        let receiptTap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleReceipt(sender:)))
        customerView.addGestureRecognizer(receiptTap2)
        //        receiptView.addGestureRecognizer(receiptTap2)
        
        let invoiceTap = UITapGestureRecognizer(target: self, action: #selector(self.handleInvoice(sender:)))
        //        invoiceView.addGestureRecognizer(invoiceTap)
        invoiceClickedView.addGestureRecognizer(invoiceTap)
        
        let invoiceTap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleInvoice(sender:)))
        invoiceView.addGestureRecognizer(invoiceTap2)
        //        invoiceClickedView.addGestureRecognizer(invoiceTap2)
        
        
        let customerStatementTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCustomerStatement(sender:)))
        //        generatedView.addGestureRecognizer(customerStatementTap)
        customerStatementView.addGestureRecognizer(customerStatementTap)
        
        let customerStatementTap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleCustomerStatement(sender:)))
        generatedView.addGestureRecognizer(customerStatementTap2)
        //        customerStatementView.addGestureRecognizer(customerStatementTap)
        
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLogout(sender:)))
        logoutView.addGestureRecognizer(logoutTap)
        
    }
    
    @objc func handleViewClicked(sender: UITapGestureRecognizer) {
        sideMenuView.isHidden = true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        // handling code
        sideMenuView.isHidden = true
    }
    
    @objc func handleSetting(sender: UITapGestureRecognizer) {
        // handling code
        sideMenuView.isHidden = true
        self.tabBarController?.selectedIndex = 1
        
    }
    
    @objc func handleReceipt(sender: UITapGestureRecognizer) {
        // handling code
        sideMenuView.isHidden = true
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReceiptsDataVC") as! ReceiptsDataVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleContract(sender: UITapGestureRecognizer) {
        // handling code
        sideMenuView.isHidden = true
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContractVC") as! ContractVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleInvoice(sender: UITapGestureRecognizer) {
        // handling code
        sideMenuView.isHidden = true
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "InvoiceVC") as! InvoiceVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleCustomerStatement(sender: UITapGestureRecognizer) {
        // handling code
        sideMenuView.isHidden = true
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomerStatementVC") as! CustomerStatementVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleLogout(sender: UITapGestureRecognizer) {
        // handling code
        UserDefaults.standard.set(false, forKey: "LOGGEDIN")
        sideMenuView.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTf.resignFirstResponder()
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomerStatementVC") as! CustomerStatementVC
        vc.text = searchTf.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func sideMenuBtn(_ sender: Any) {
        sideMenuView.isHidden = false
        sideMenuView.backgroundColor = .white
        self.view.bringSubviewToFront(sideMenuView)
        if !isSideViewOpen {
            isSideViewOpen = true
            sideMenuView.frame = CGRect(x: 0, y: 0, width: 0, height: 775)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil )
            sideMenuView.frame = CGRect(x: 0, y: 0, width: 320, height: 775)
            UIView.commitAnimations()
        }
    }
    
}
