//
//  Alert.swift
//  Klaxon
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import UIKit

public extension UIAlertAction {
    enum ActionStyle {
        case dismiss
        case retry
        case destructive
    }
    
    convenience init(title: String?, style: ActionStyle = .dismiss, handler: @escaping () -> Void = {}) {
        self.init(title: title, style: style.value, handler: { _ in handler() })
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
        let action = UIAlertAction(title: actionTitle, handler: handler)
        alert.addAction(action)
        show(alert)
    }
    
    func showAlert(withTitle title: String, message: String? = nil, handler: @escaping () -> Void = {}) {
        let actionTitle = Strings.okLabel.localized
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, handler: handler)
        alert.addAction(action)
        show(alert)
    }
    
    func showConfirmationAlert(withTitle title: String, message: String? = nil, confirmActionTitle: String? = nil, preferredStyle: UIAlertControllerStyle = .alert, handler: @escaping () -> Void) {
        let confirmActionTitle = confirmActionTitle ?? Strings.okLabel.localized
        let confirmActionStyle: UIAlertAction.ActionStyle = (preferredStyle == .actionSheet) ? .destructive : .dismiss
        let cancelActionTitle = Strings.cancelLabel.localized
        let cancelActionStyle: UIAlertActionStyle = (preferredStyle == .actionSheet) ? .cancel : .default
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: confirmActionStyle, handler: handler)
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: cancelActionStyle)
        let actions = (preferredStyle == .actionSheet) ? [confirmAction, cancelAction] : [cancelAction, confirmAction]
        actions.forEach { alert.addAction($0) }
        alert.preferredAction = cancelAction
        show(alert)
    }
}

private extension UIViewController {
    func show(_ alert: UIAlertController) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = AlertViewController(statusBarStyle: preferredStatusBarStyle)
        alertWindow.isHidden = false
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.rootViewController!.present(alert, animated: true, completion: nil)
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

private extension UIAlertAction.ActionStyle {
    var value: UIAlertActionStyle {
        switch self {
        case .dismiss:
            return .default
        case .retry:
            return .cancel
        case .destructive:
            return .destructive
        }
    }
}
