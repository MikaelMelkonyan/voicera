//
//  EventsViewController.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    
    // Informaton
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var informationTitle: UILabel!
    @IBOutlet weak var informationDescription: UILabel!
    @IBOutlet weak var informationButton: VoiceraButton!
    
    // Other
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel = EventsViewModel { [weak self] in
        self?.view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.checkPermissions()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switch viewModel.state {
        case .loading:
            informationView.isHidden = true
            loader.isHidden = false
            tableView.isHidden = true
        case .permissionError:
            informationView.isHidden = false
            loader.isHidden = true
            tableView.isHidden = true
            updateInformation()
        case .success:
            informationView.isHidden = true
            loader.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func updateInformation() {
        guard case let .permissionError(state) = viewModel.state else {
            return
        }
        
        switch state {
        case .denied:
            informationTitle.text = "Oops..."
            informationDescription.text = "Seems like you haven't connected calendar. Please add permissions for the application in device settings"
            informationButton.setTitle("Check settings", for: .normal)
        case .notDetermined:
            informationTitle.text = "Hello"
            informationDescription.text = "Glad to see you first time. Connect calendar to see upcoming meetings"
            informationButton.setTitle("Connect", for: .normal)
        }
    }
    
    @IBAction func goToSettings(_ sender: VoiceraButton) {
        guard case let .permissionError(state) = viewModel.state else {
            return
        }
        
        switch state {
        case .notDetermined:
            viewModel.requestAccess()
        case .denied:
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    }
}
