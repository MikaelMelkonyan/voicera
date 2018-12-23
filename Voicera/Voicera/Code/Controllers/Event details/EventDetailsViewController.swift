//
//  EventDetailsViewController.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit
import EventKit.EKEvent

class EventDetailsViewController: UIViewController {
    
    weak var event: EKEvent?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Event Details"
        
        guard let event = event else {
            let unknown = "Unknown"
            titleLabel.text = unknown
            notes.text = unknown
            date.text = unknown
            return
        }
        
        titleLabel.text = event.title
        notes.text = event.notes ?? "Not specified"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        date.text = formatter.string(from: event.startDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
}
