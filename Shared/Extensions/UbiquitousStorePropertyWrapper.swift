//
//  UserDefaultPropertyWrapper.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import Foundation

@propertyWrapper
struct UbiquitousStore<T> {
    let key: String
    let defaultValue: T
    let fallbackToUserDefaults: Bool

    init(_ key: String, defaultValue: T, fallbackToUserDefaults: Bool = false) {
        self.key = key
        self.defaultValue = defaultValue
        self.fallbackToUserDefaults = fallbackToUserDefaults
    }

    var wrappedValue: T {
        get {
            return NSUbiquitousKeyValueStore.default.object(forKey: key) as? T ??
                    (fallbackToUserDefaults ? UserDefaults.standard.object(forKey: key) as? T : nil) ??
                    defaultValue
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil() {
                NSUbiquitousKeyValueStore.default.removeObject(forKey: key)
            } else {
                NSUbiquitousKeyValueStore.default.set(newValue, forKey: key)
            }
            NSUbiquitousKeyValueStore.default.synchronize()
        }
    }
}

fileprivate protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional: OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }
}
