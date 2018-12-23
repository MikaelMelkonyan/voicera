//
//  EventsViewModel.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import EventKit.EKEvent

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
    
    func insert(newEvent event: EKEvent) {
        guard case let .success(state) = state, case let .events(events) = state else {
            checkPermissions()
            return
        }
        var new = events
        new.insert(event, at: 0)
        new.sort { $0.startDate > $1.startDate }
        self.state = .success(.events(new))
    }
}

extension EventsViewModel {
    
    private func loadEvents() {
        background {
            do {
                var events = try EventManager.shared.loadEvents()
                if events.isEmpty {
                    self.state = .success(.empty)
                } else {
                    events.sort { $0.startDate > $1.startDate }
                    self.state = .success(.events(events))
                }
            } catch {
                self.state = .success(.error(error.localizedDescription))
            }
        }
    }
}
