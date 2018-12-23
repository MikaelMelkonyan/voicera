//
//  EventManager.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import EventKit

class EventManager {
    
    private init() {}
    static let shared = EventManager()
    
    private let eventStore = EKEventStore()
    
    func getPermissionStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    func requestAccess(completion: @escaping ((Bool) -> ())) {
        eventStore.requestAccess(to: .event) { isAllowed, _ in
            completion(isAllowed)
        }
    }
    
    func loadEvents() throws -> [EKEvent] {
        do {
            let calendar = try getCalendar()
            
            let halfYearAgo     = Date(timeIntervalSinceNow: -180 * 24 * 3600)
            let halfYearAfter   = Date(timeIntervalSinceNow: +180 * 24 * 3600)
            
            let predicate = eventStore.predicateForEvents(withStart: halfYearAgo, end: halfYearAfter, calendars: [calendar])
            let events = eventStore.events(matching: predicate)
            return events
        } catch {
            assertionFailure(error.localizedDescription)
            throw error
        }
    }
    
    private func getCalendar() throws -> EKCalendar {
        if let calendar = eventStore.calendars(for: .event).first(where: { $0.title == "Voicera" }) {
            return calendar
        }
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar.title = "Voicera"
        calendar.source = eventStore.sources.first {
            $0.sourceType.rawValue == EKSourceType.local.rawValue
        }
        do {
            try eventStore.saveCalendar(calendar, commit: true)
            return calendar
        } catch {
            throw error
        }
    }
    
    func createEvent(with title: String, date: Date, notes: String?) throws -> EKEvent {
        let calendar = try getCalendar()
        
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = date
        event.endDate = date
        event.notes = notes
        event.calendar = calendar
        
        do {
            try eventStore.save(event, span: .thisEvent)
            return event
        } catch {
            throw error
        }
    }
}
