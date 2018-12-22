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
}
