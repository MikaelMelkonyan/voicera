//
//  UINavigationBar.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func configureWithVoiceaStyle() {
        tintColor = .black
        prefersLargeTitles = true
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        titleTextAttributes = [.font: UIFont.poppins(size: 17, weight: .medium)]
        largeTitleTextAttributes = [.font: UIFont.poppins(size: 32, weight: .semiBold)]
        isTranslucent = true
    }
}
