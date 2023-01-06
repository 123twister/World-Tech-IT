//
//  ViewController.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 08/01/21.
//

import UIKit
import SVProgressHUD
import Network

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var emailHideLbl: UILabel!
    @IBOutlet weak var passwordHideLbl: UILabel!
    
    //MARK:- PROPERTIES
    
    
    // MARK:- FUNCTION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobileNetwork()
        emailTF.text = UserDefaults.standard.string(forKey: "EMAIL") ?? ""
        passwordTF.text = UserDefaults.standard.string(forKey: "PASSWORD") ?? ""
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        emailHideLbl.isHidden = true
        passwordHideLbl.isHidden = true
        
        emailView.layer.borderColor = UIColor.white.cgColor
        emailView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.white.cgColor
        passwordView.layer.borderWidth = 1
        
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if  UserDefaults.standard.bool(forKey: "LOGGEDIN") == true{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabController")
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func loginUser()
    {
        SVProgressHUD.show()
        let email = emailTF.text
        let password = passwordTF.text
        
        
        if (email == "") || (password == ""){
            SVProgressHUD.dismiss()
            emailView.layer.borderColor = UIColor.red.cgColor
            emailView.layer.borderWidth = 1
            emailHideLbl.isHidden = false
            passwordView.layer.borderColor = UIColor.red.cgColor
            passwordHideLbl.isHidden = false
            passwordView.layer.borderWidth = 1
        }
        if email?.isEmailValid == false {
            SVProgressHUD.dismiss()
            self.emailView.layer.borderColor = UIColor.red.cgColor
            self.emailView.layer.borderWidth = 1
            self.emailHideLbl.isHidden = false
        }
        
            if let url = URL(string: "http://worldtech.tradeguruweb.com/api/v1/login-user"){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let params = [
                    
                    "email": email ?? "",
                    "password": password ?? ""
                    
                ]
                
                guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                else {
                    return
                    }
                request.httpBody = httpBody
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if error == nil{
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                            print("LOGIN Data -> \(json)")
                            if let success = json["status"]{
                                if success as! String == "false"
                                {
                                    DispatchQueue.main.async
                                    {
                                        SVProgressHUD.dismiss()
                                        self.displayAlertMessage(userMessage:"Please check if email or password is correct.")
                                    }
                                }else
                                {
                                    print("API executed successfully!!! ✅ ")
                                    let defaults = UserDefaults.standard
                                    let user_id = json["user_id"]
                                    let access_token = json["token"]
                                    defaults.setValue(user_id, forKey: "ID")
                                    defaults.setValue(access_token, forKey: "ACCESS_TOKEN")
                                    defaults.setValue(email, forKey: "EMAIL")
                                    defaults.setValue(password, forKey: "PASSWORD")
                                   
                                    defaults.synchronize()
                                    
                                    DispatchQueue.main.async {
                                        
                                        //                                    print("\(self.user_ID)")
                                        SVProgressHUD.dismiss()
                                        
                                        UserDefaults.standard.set(true, forKey: "LOGGEDIN")
                                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabController")
                                        self.navigationController?.pushViewController(vc, animated: true)
                                        
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
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        return true
    }
    
    //MARK:- ACTIONS
    
    @IBAction func loginClicked(_ sender: Any) {
        loginUser()
    }
    
    
}




