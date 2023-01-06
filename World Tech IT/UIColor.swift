//
//  UIColor.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 08/01/21.
//

import UIKit

extension UIColor {
    
    static let lightOrange = UIColor(hex: 0xFB8D29)
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0)
    {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(hex: Int, a: CGFloat = 1.0)
    {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: (hex) & 0xFF,
            a: a
        )
    }

    
}
