//
//  EventCell.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit
import EventKit.EKEvent

class EventCell: SimpleCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var titleToBackView: NSLayoutConstraint!
    @IBOutlet weak var titleToNotes: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.crop(radius: kCropRadius)
        shadowView.setShadow(opacity: kShadowsOpacity, color: .black, radius: kShadowsRadius)
        backView.crop(radius: kCropRadius)
        dateView.crop(radius: kCropRadius / 2)
    }
    
    func fill(event: EKEvent) {
        titleLabel.text = event.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        dateLabel.text = formatter.string(from: event.startDate)
        
        if let notes = event.notes, !notes.isEmpty {
            notesLabel.text = notes
            titleToNotes.priority = .defaultHigh
            titleToBackView.priority = .defaultLow
        } else {
            notesLabel.text = nil
            titleToNotes.priority = .defaultLow
            titleToBackView.priority = .defaultHigh
        }
        layoutIfNeeded()
    }
}
