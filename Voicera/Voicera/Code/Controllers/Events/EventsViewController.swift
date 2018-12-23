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
        
        setupView()
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
            tableView.reloadData()
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
    
    private func openEventCretaing() {
        let vc = AppStoryboard.AddEvent.instance.instantiateViewController(withIdentifier: AddEventViewController.storyboardID) as! AddEventViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case let .success(state) = viewModel.state else {
            return 0
        }
        
        switch state {
        case .empty, .error:
            return 1
        case let .events(events):
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let .success(state) = viewModel.state else {
            return SimpleCell()
        }
        
        switch state {
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddEventCell", for: indexPath) as! AddEventCell
            cell.fill { [weak self] in
                self?.openEventCretaing()
            }
            return cell
        case let .error(text):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorInformationCell", for: indexPath) as! ErrorInformationCell
            cell.fill(description: text) { [weak self] in
                self?.viewModel.checkPermissions()
            }
            return cell
        case let .events(events):
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
            // todo
            return cell
        }
    }
}

// MARK: View building
extension EventsViewController {
    
    private func setupView() {
        title = "Voicea"
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        navigationBar.tintColor = .black
        navigationBar.prefersLargeTitles = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [.font: UIFont.poppins(size: 17, weight: .medium)]
        navigationBar.largeTitleTextAttributes = [.font: UIFont.poppins(size: 32, weight: .semiBold)]
        navigationBar.isTranslucent = true
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        tableView.register(UINib(nibName: "AddEventCell", bundle: nil), forCellReuseIdentifier: "AddEventCell")
        tableView.register(UINib(nibName: "ErrorInformationCell", bundle: nil), forCellReuseIdentifier: "ErrorInformationCell")
    }
}
