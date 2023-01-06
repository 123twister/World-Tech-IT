//
//  String Validations.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 02/02/21.
//

import Foundation

extension String {
    
    static let baseUrl = "http://worldtech.tradeguruweb.com"
    static let localhostUrl = "http://127.0.0.1:8000"

//    var isPasswordValid: Bool {
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
//        return passwordTest.evaluate(with: self)
//    }

    var isEmailValid: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9]+\\.[A-Za-z]{3}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return emailTest.evaluate(with: self)
    }
}
