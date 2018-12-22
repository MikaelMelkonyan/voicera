//
//  UIView.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

extension UIView {
    
    func addGradient(colors: (UIColor, UIColor), isHorizontal: Bool = false, crop: CGFloat? = nil) {
        if let gradientSubLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientSubLayer.colors = [colors.0.cgColor, colors.1.cgColor]
            gradientSubLayer.frame = bounds
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = [colors.0.cgColor, colors.1.cgColor]
            if isHorizontal {
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            }
            if let crop = crop {
                gradientLayer.cornerRadius = crop
                gradientLayer.masksToBounds = false
            }
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func crop(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
