//
//  EventCell.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit
import EventKit.EKEvent

class EventCell: PressableCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var reminderButton: VoiceraButton!
    
    private var event: EKEvent?
    private var isReminderSet: Bool?
    private var reminderAction: ((Bool, EKEvent) -> ())?
    private var openEvent: ((EKEvent) -> ())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.crop(radius: kCropRadius)
        shadowView.setShadow(opacity: kShadowsOpacity, color: .black, radius: kShadowsRadius)
        backView.crop(radius: kCropRadius)
        dateView.crop(radius: kCropRadius / 2)
    }
    
    func fill(event: EKEvent, isReminderSet: Bool, reminder: @escaping ((Bool, EKEvent) -> ()), openEvent: @escaping ((EKEvent) -> ())) {
        self.event = event
        self.isReminderSet = isReminderSet
        self.openEvent = openEvent
        titleLabel.text = event.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        dateLabel.text = formatter.string(from: event.startDate)
        
        reminderButton.setTitle(isReminderSet ? "Cancel" : "Set" + " reminder", for: .normal)
        reminderAction = reminder
        
        reminderButton.isHidden = event.startDate <= Date()
    }
    
    @IBAction func changeReminder(_ sender: VoiceraButton) {
        guard let event = event, let isReminderSet = isReminderSet else {
            return
        }
        reminderAction?(!isReminderSet, event) // todo
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let event = self.event else {
            return
        }
        openEvent?(event)
    }
}
