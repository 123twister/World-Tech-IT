//
//  LaunchViewController.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 12/02/21.
//

import UIKit
import LocalAuthentication

class LaunchViewController: UIViewController {

    let context = LAContext()
    var error: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authentiationError in
                DispatchQueue.main.async {
                    if success{
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self?.navigationController?.pushViewController(vc, animated: false)
                    }else
                    {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified, please try again!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            self?.navigationController?.pushViewController(vc, animated: false)
                        }))

                        self?.present(ac, animated: true)
                    }
                }
                
            }
            
        } else
        {
            // NO Biometry
            let ac = UIAlertController(title: "Biometry failed", message: "You device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(vc, animated: false)
            }))
            present(ac, animated: true)
        }
    }
    

}
