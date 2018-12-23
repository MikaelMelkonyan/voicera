//
//  ErrorInformationCell.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class ErrorInformationCell: SimpleCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var reloadAction: (() -> ())?
    
    func fill(description: String, reload: @escaping (() -> ())) {
        descriptionLabel.text = description
        reloadAction = reload
    }
    
    @IBAction func reload(_ sender: VoiceraButton) {
        reloadAction?()
    }
}
