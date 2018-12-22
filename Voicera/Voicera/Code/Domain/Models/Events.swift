//
//  Events.swift
//  Voicera
//
//  Created by Mikael on 12/22/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

extension EventsViewModel {
    
    enum State {
        case loading
        case permissionError(PermissionErrorState)
        case success
        
        enum PermissionErrorState {
            case notDetermined
            case denied
        }
    }
}
