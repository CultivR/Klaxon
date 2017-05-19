//
//  Alert.swift
//  Klaxon
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import UIKit

public extension UIAlertAction {
    enum Style {
        case dismiss
        case retry
        case destructive
    }
    
    convenience init(title: String?, style: Style = .dismiss, handler: @escaping () -> Void = {}) {
        self.init(title: title, style: style.value, handler: { _ in handler() })
    }
}

public extension UIAlertController {
    static func showError(title: String? = nil, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        alert.show()
    }
    
    static func showError(title: String? = nil, message: String, handler: @escaping () -> Void = {}) {
        let actionTitle = Strings.okLabel.localized
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, handler: handler)
        alert.addAction(action)
        alert.show()
    }
    
    static func showConfirmation(forAction action: String, context: String?, handler: @escaping () -> Void) {
        let cancelActionTitle = Strings.cancelLabel.localized
        let alert = UIAlertController(title: context, message: nil, preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: action, style: .destructive, handler: handler)
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        alert.show()
    }
}

private extension UIAlertController {
    func show() {
        let rootViewController = UIApplication.shared.windows.last!.rootViewController!
        rootViewController.present(self, animated: true, completion: nil)
    }
}

private extension UIAlertAction.Style {
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
