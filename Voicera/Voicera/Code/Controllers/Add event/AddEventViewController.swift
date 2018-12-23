//
//  AddEventViewController.swift
//  Voicera
//
//  Created by Mikael on 12/23/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit
import EventKit.EKEvent

class AddEventViewController: UIViewController {
    
    var successCompletion: ((EKEvent) -> ())?
    
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    // Title
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLine: UIView!
    // Notes
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesLine: UIView!
    // Date
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @objc private func createEvent() {
        guard let title = titleTextField.text else {
            return
        }
        
        do {
            let event = try EventsManager.shared.createEvent(with: title, date: datePicker.date, notes: notesTextView.text)
            dismiss(animated: true) { [weak self] in
                self?.successCompletion?(event)
            }
        } catch {
            showAlert(error.localizedDescription, title: "Event adding error")
        }
    }
    
    @objc private func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func backTap() {
        view.endEditing(false)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dateValue.text = formatter.string(from: sender.date)
    }
}

// MARK: View building
extension AddEventViewController {
    
    private func setupView() {
        title = "New event"
        let tap = UITapGestureRecognizer(target: self, action: #selector(backTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        setupNavBar()
        setupInputs()
    }
    
    private func setupNavBar() {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.poppins(size: 17),
            .foregroundColor: UIColor.darkBlue
        ]
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeVC))
        cancel.setTitleTextAttributes(textAttributes, for: .normal)
        cancel.setTitleTextAttributes(textAttributes, for: .highlighted)
        cancel.setTitleTextAttributes(textAttributes, for: .selected)
        
        navigationItem.setLeftBarButton(cancel, animated: false)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.configureWithVoiceaStyle()
        
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(createEvent))
        add.setTitleTextAttributes(textAttributes, for: .normal)
        add.setTitleTextAttributes(textAttributes, for: .highlighted)
        add.setTitleTextAttributes(textAttributes, for: .selected)
        add.setTitleTextAttributes([.font: UIFont.poppins(size: 17), .foregroundColor: UIColor.lightGray], for: .disabled)
        navigationItem.setRightBarButton(add, animated: false)
        
        updateAddButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeKeyboardObservers(active: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeKeyboardObservers(active: false)
    }
    
    private func setupInputs() {
        titleTextField.accessibilityIdentifier = "title"
        titleTextField.delegate = self
        titleTextField.returnKeyType = .next
        titleTextField.addTarget(self, action: #selector(textFieldValueDidChange(_:)), for: .editingChanged)
        
        notesTextView.accessibilityIdentifier = "notes"
        notesTextView.textContainerInset = .zero
        notesTextView.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        notesTextView.delegate = self
        
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        var currentDate = Date()
        var hours = currentDate.timeIntervalSince1970 / 3600
        hours.round(.down)
        hours += 1
        hours *= 3600
        currentDate = Date(timeIntervalSince1970: hours)
        
        datePicker.date = currentDate
        dateValue.text = formatter.string(from: datePicker.date)
    }
    
    private func updateAddButtonState() {
        let isEmptyOrNil = titleTextField.text?.isEmpty ?? true
        navigationItem.rightBarButtonItem?.isEnabled = !isEmptyOrNil
    }
}

// MARK: TextField inputs delegate
extension AddEventViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.accessibilityIdentifier == "title" else {
            return
        }
        titleLine.backgroundColor = .blue
    }
    
    @objc private func textFieldValueDidChange(_ textField: UITextField) {
        guard textField.accessibilityIdentifier == "title" else {
            return
        }
        updateAddButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.accessibilityIdentifier == "title" else {
            return
        }
        updateAddButtonState()
        titleLine.backgroundColor = .lightGray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.accessibilityIdentifier == "title" {
            notesTextView.becomeFirstResponder()
        }
        return true
    }
}

// MARK: TextView inputs delegate
extension AddEventViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.accessibilityIdentifier == "notes" else {
            return
        }
        notesLine.backgroundColor = .blue
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.accessibilityIdentifier == "notes" else {
            return
        }
        notesLine.backgroundColor = .lightGray
    }
}

// MARK: Keyboard observers
extension AddEventViewController {
    
    private func changeKeyboardObservers(active: Bool) {
        if active {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    @objc private func keyboardShown(notification: NSNotification) {
        let keyboardFrame: CGRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollViewBottom.constant = keyboardFrame.height - (UIDevice.current.isXFamily ? 34 : 0)
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    
    @objc private func keyboardHidden(notification: NSNotification) {
        scrollViewBottom.constant = 0
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
}
