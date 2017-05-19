//
//  Strings.swift
//  Klaxon
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Foundation

enum Strings: String {
    case cancelLabel
    case okLabel
    
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
    
    func localized(_ args: CVarArg...) -> String {
        let localized = NSLocalizedString(rawValue, comment: "")
        return String(format: localized, locale: Locale.current, arguments: args)
    }
}
