//
//  Events.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import EventKit.EKEvent

extension EventsViewModel {
    
    enum State {
        case loading
        case permissionError(PermissionErrorState)
        case success(SuccessState)
        
        enum PermissionErrorState {
            case notDetermined
            case denied
        }
        
        enum SuccessState {
            case events([(event: EKEvent, isReminderActive: Bool)])
            case empty
            case error(String)
        }
    }
}
