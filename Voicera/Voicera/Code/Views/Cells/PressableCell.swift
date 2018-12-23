//
//  PressableCell.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class PressableCell: SimpleCell {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform.identity })
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform.identity })
    }
}
