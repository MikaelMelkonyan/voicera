//
//  NotificationsManager.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UserNotifications

class NotificationsManager {
    
    private init() {}
    static let shared = NotificationsManager()
    
    private let center = UNUserNotificationCenter.current()
    
    func getNotificationIds(completion: @escaping (([String]) -> ())) {
        center.getPendingNotificationRequests { requests in
            let ids = requests.compactMap { $0.identifier }
            completion(ids)
        }
    }
    
    func cancelNotification(by id: String) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func createNotification(id: String, title: String, notes: String?, at date: Date, completion: @escaping ((Bool, String?) -> ())) {
        checkPermissions { isAllowed in
            if isAllowed {
                let content = UNMutableNotificationContent()
                content.title = "The event is starting now"
                content.subtitle = title
                if let notes = notes, !notes.isEmpty {
                    content.body = notes
                }
                content.sound = .default
                
                let interval = date.timeIntervalSince(Date())
                guard interval > 0 else {
                    completion(false, "Start date and time must be later than now")
                    return
                }
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                self.center.add(request) { error in
                    if let error = error {
                        completion(false, error.localizedDescription)
                    } else {
                        completion(true, nil)
                    }
                }
            } else {
                completion(false, "Seems like the application hasn't permissions to send you notifications. Please check status in device settings")
            }
        }
    }
    
    private func checkPermissions(completion: @escaping ((Bool) -> ())) {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                completion(true)
            case .denied:
                completion(false)
            case .notDetermined:
                self.center.requestAuthorization(options: [.alert, .sound]) { result, _ in
                    completion(result)
                }
            }
        }
    }
}
