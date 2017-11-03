//
//  Error.swift
//  Klaxon
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

public protocol DisplayableError: Error {
    var name: String { get }
    var description: String? { get }
}

extension Error {
    var name: String {
        return (self as? DisplayableError)?.name ?? Strings.errorLabel.localized
    }
    
    var description: String? {
        return (self as? DisplayableError)?.description
    }
}
