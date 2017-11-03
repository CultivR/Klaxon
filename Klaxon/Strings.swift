//
//  Strings.swift
//  Klaxon
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

enum Strings: String {
    case cancelLabel
    case errorLabel
    case okLabel
    
    var localized: String {
        let bundle = Bundle(for: BundleObject.self)
        return NSLocalizedString(rawValue, bundle: bundle, comment: "")
    }
    
    func localized(_ args: CVarArg...) -> String {
        return String(format: localized, locale: Locale.current, arguments: args)
    }
}

public extension String {
    static var defaultErrorName: String {
        return Strings.errorLabel.localized
    }
}

private class BundleObject {}
