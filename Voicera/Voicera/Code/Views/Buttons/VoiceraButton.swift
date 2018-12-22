//
//  VoiceraButton.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class VoiceraButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.poppins(size: 15, weight: .medium)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 33, bottom: 0, right: 33)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient(colors: (.darkBlue, .blue), isHorizontal: true)
        crop(radius: 3)
    }
}
