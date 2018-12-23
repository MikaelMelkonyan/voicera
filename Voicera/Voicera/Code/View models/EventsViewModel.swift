//
//  EventsViewModel.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import EventKit.EKEvent

class EventsViewModel {
    
    private weak var view: EventsView?
    init(view: EventsView) {
        self.view = view
        
        NotificationsManager.shared.getNotificationIds() {
            self.notificationsIds = $0
        }
    }
    
    var state: State = .loading {
        didSet {
            main {
                self.view?.updateView()
            }
        }
    }
    
    private var notificationsIds = [String]() {
        didSet {
            checkPermissions()
        }
    }
}

extension EventsViewModel {
    
    func checkPermissions() {
        state = .loading
        background {
            let status = EventsManager.shared.getPermissionStatus()
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
        EventsManager.shared.requestAccess { [weak self] isAllowed in
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
        new.insert((event: event, isReminderActive: false), at: 0)
        new.sort { $0.event.startDate > $1.event.startDate }
        self.state = .success(.events(new))
    }
    
    func setReminder(for event: EKEvent) {
        NotificationsManager.shared.createNotification(id: event.eventIdentifier, title: event.title, notes: event.notes, at: event.startDate) { isSuccess, error in
            if isSuccess {
                self.updateNotificationsList()
            } else {
                self.view?.showAlert(title: "Notification adding error", message: error!)
            }
        }
    }
    
    func cancelReminder(for event: EKEvent) {
        NotificationsManager.shared.cancelNotification(by: event.eventIdentifier)
        updateNotificationsList()
    }
    
    private func updateNotificationsList() {
        NotificationsManager.shared.getNotificationIds() {
            self.notificationsIds = $0
        }
    }
}

extension EventsViewModel {
    
    private func loadEvents() {
        background {
            do {
                var events = try EventsManager.shared.loadEvents()
                if events.isEmpty {
                    self.state = .success(.empty)
                } else {
                    events.sort { $0.startDate > $1.startDate }
                    let array: [(event: EKEvent, isReminderActive: Bool)] = events.map {
                        (event: $0, isReminderActive: self.notificationsIds.contains($0.eventIdentifier))
                    }
                    self.state = .success(.events(array))
                }
            } catch {
                self.state = .success(.error(error.localizedDescription))
            }
        }
    }
}
