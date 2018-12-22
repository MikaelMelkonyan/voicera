//
//  UIFont.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func poppins(size: CGFloat, weight: FontWeight = .regular) -> UIFont {
        let weightName = weight.rawValue.prefix(1).uppercased() + weight.rawValue.dropFirst()
        return UIFont(descriptor: UIFontDescriptor(name: "Poppins \(weightName)", size: size), size: size)
    }
    
    enum FontWeight: String {
        case light, regular, medium, semiBold, bold
    }
}
