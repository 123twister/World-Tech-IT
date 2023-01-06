//
//  ProfileVC.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 23/02/21.
//

import UIKit

class ProfileVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTf.delegate = self
        passwordTf.delegate = self
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTf.resignFirstResponder()
        passwordTf.resignFirstResponder()
        
        return true
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "LOGGEDIN")
        self.tabBarController?.tabBar.isHidden = true
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
