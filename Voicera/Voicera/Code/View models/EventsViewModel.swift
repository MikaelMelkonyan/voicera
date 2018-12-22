//
//  EventsViewModel.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

class EventsViewModel {
    
    private let updateView: (() -> ())
    init(update: @escaping (() -> ())) {
        updateView = update
    }
    
    var state: State = .loading {
        didSet {
            main {
                self.updateView()
            }
        }
    }
}

extension EventsViewModel {
    
    func checkPermissions() {
        state = .loading
        background {
            let status = EventManager.shared.getPermissionStatus()
            switch status {
            case .authorized:
                self.loadEvents()
            case .notDetermined:
                self.state = .permissionError(.notDetermined)
            case .denied, .restricted:
                self.state = .permissionError(.denied)
            }
        }
    }
    
    func requestAccess() {
        EventManager.shared.requestAccess { [weak self] isAllowed in
            if isAllowed {
                self?.loadEvents()
            } else {
                self?.state = .permissionError(.denied)
            }
        }
    }
}

extension EventsViewModel {
    
    private func loadEvents() {
        self.state = .success
    }
}
