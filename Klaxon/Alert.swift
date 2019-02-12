//
//  Alert.swift
//  Klaxon
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import UIKit

public extension UIAlertController {
    struct Field {
        let style: Style
        let text: String?
        let placeholderText: String?
        let isSecure: Bool
        
        public init(style: Style, text: String? = nil, placeholderText: String? = nil, isSecure: Bool = false) {
            self.style = style
            self.text = text
            self.placeholderText = placeholderText
            self.isSecure = isSecure
        }
    }
    
    enum Input {
        case text(String?)
        case date(Date?)
    }
}

public extension UIAlertController.Field {
    enum Style {
        case text(autocapitalizationType: UITextAutocapitalizationType)
        case date
    }
}

public extension UIViewController {
    func showAlert(for error: Error, actions: [UIAlertAction]) {
        let title = error.name
        let message = error.description
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        show(alert)
    }
    
    func showAlert(for error: Error, handler: @escaping () -> Void = {}) {
        let title = error.name
        let message = error.description
        let actionTitle = Strings.okLabel.localized
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: { _ in handler() })
        alert.addAction(action)
        show(alert)
    }
    
    func showAlert(title: String, message: String? = nil, handler: @escaping () -> Void = {}) {
        let actionTitle = Strings.okLabel.localized
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: { _ in handler() })
        alert.addAction(action)
        show(alert)
    }
    
    func showConfirmationAlert(title: String, message: String? = nil, confirmActionTitle: String? = nil, fields: [UIAlertController.Field] = [], preferredStyle: UIAlertController.Style = .alert, handler: @escaping ([UIAlertController.Input]) -> Void) {
        let confirmActionTitle = confirmActionTitle ?? Strings.okLabel.localized
        let cancelActionTitle = Strings.cancelLabel.localized
        showAlert(title: title, message: message, leftActionTitle: cancelActionTitle, rightActionTitle: confirmActionTitle, fields: fields, preferredStyle: preferredStyle, handler: handler)
    }

    func showAlert(title: String, message: String? = nil, leftActionTitle: String, rightActionTitle: String, fields: [UIAlertController.Field] = [], preferredStyle: UIAlertController.Style = .alert, preferredActionIndex: Int = 0, handler: @escaping ([UIAlertController.Input]) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let leftAction = UIAlertAction(title: leftActionTitle, style: .default)
        let rightAction = UIAlertAction(title: rightActionTitle, style: .default) { [weak alert] _ in
            guard let alert = alert, fields.count > 0 else { return }
            let textFields = alert.textFields!
            let inputs = fields.enumerated().map { index, field -> UIAlertController.Input in
                let textField = textFields[index]
                switch field.style {
                case .text:
                    return .text(textField.text)
                case .date:
                    let datePicker = textField.inputView as! UIDatePicker
                    let date = (textField.text?.count ?? 0 > 0) ? datePicker.date : nil
                    return .date(date)
                }
            }
            handler(inputs)
        }
        
        let actions = (preferredStyle == .actionSheet) ? [rightAction, leftAction] : [leftAction, rightAction]
        for field in fields {
            alert.addTextField { textField in
                textField.text = field.text
                textField.placeholder = field.placeholderText
                textField.isSecureTextEntry = field.isSecure
                
                switch field.style {
                case let .text(autocapitalizationType):
                    textField.autocapitalizationType = autocapitalizationType
                case .date:
                    let datePicker = AlertDatePicker(textField: textField)
                    textField.inputView = datePicker
                }
            }
        }
        actions.forEach { alert.addAction($0) }
        alert.preferredAction = actions[preferredActionIndex]
        
        show(alert)
    }
}

private extension UIViewController {
    func show(_ alert: UIAlertController) {
//        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//        alertWindow.rootViewController = AlertViewController(statusBarStyle: preferredStatusBarStyle)
//        alertWindow.isHidden = false
//        alertWindow.windowLevel = UIWindowLevelAlert + 1
//        alertWindow.rootViewController!.present(alert, animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
    }
}

private class AlertViewController: UIViewController {
    private var statusBarStyle: UIStatusBarStyle
    
    init(statusBarStyle: UIStatusBarStyle) {
        self.statusBarStyle = statusBarStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: UIViewController
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

private class AlertDatePicker: UIDatePicker {
    private let textField: UITextField
    private let formatter = DateFormatter()
    
    init(textField: UITextField) {
        self.textField = textField
        super.init(frame: .zero)
        minimumDate = Date()
        datePickerMode = .date
        formatter.dateStyle = .long
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func valueChanged() {
        textField.text = formatter.string(from: date)
    }
}
