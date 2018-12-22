//
//  UIColor.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

extension UIColor {
    
    private convenience init(red: Int64, green: Int64, blue: Int64, alpha: CGFloat? = nil) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha ?? 1.0)
    }
    
    private convenience init(hex: Int64, alpha: CGFloat? = nil) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff, alpha: alpha)
    }
    
    class var darkBlue: UIColor         { return UIColor(hex: 0x4a77f4) }
    class var blue: UIColor             { return UIColor(hex: 0x00bade) }
}
