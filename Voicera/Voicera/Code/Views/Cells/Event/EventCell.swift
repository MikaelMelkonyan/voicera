//
//  EventCell.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class EventCell: SimpleCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.crop(radius: kCropRadius)
        shadowView.setShadow(opacity: kShadowsOpacity, color: .black, radius: kShadowsRadius)
        backView.crop(radius: kCropRadius)
    }
}
