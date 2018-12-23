//
//  EventsView.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

protocol EventsView: class {
    func updateView()
    func showAlert(title: String, message: String)
}
