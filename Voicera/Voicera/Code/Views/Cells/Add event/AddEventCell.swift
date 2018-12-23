//
//  AddEventCell.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class AddEventCell: PressableCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.crop(radius: kCropRadius)
        shadowView.setShadow(opacity: kShadowsOpacity, color: .black, radius: kShadowsRadius)
        backView.crop(radius: kCropRadius)
    }
    
    private var addEvent: (() -> ())?
    
    func fill(addEvent: @escaping (() -> ())) {
        self.addEvent = addEvent
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        addEvent?()
    }
}
