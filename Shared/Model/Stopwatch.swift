//
//  Stopwatch.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

class Stopwatch {
    static let stateChangedNotification = Notification.Name("Stopwatch.StateChangedNotification.Name")
    static let shared = Stopwatch()
    
    private init() {
        // Migrate start time from user defaults and use of CACurrentMediaTime
        if let oldStartTime = UserDefaults.standard.object(forKey: "startTime") as? Double {
            startTime = oldStartTime + CFAbsoluteTimeGetCurrent() - CACurrentMediaTime()
            UserDefaults.standard.removeObject(forKey: "startTime")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyStateObservers), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
    }
    
    // MARK: - Values (persistent)
    
    /// If this stopwatch is actively running, the time it was started at.
    @UbiquitousStore("startTime", defaultValue: nil, fallbackToUserDefaults: false)
    private var startTime: CFTimeInterval?
    
    /// If this stopwatch was paused, the duration at the time it was paused.
    @UbiquitousStore("pausedAtDuration", defaultValue: nil)
    private var pausedAtDuration: CFTimeInterval?
    
    // MARK: - State
    
    /// The current duration of this stopwatch.
    var duration: CFTimeInterval {
        get {
            if let startTime = startTime {
                return CFAbsoluteTimeGetCurrent() - startTime
            } else if let pausedAtDuration = pausedAtDuration {
                return pausedAtDuration
            }
            return 0
        }
        set {
            if startTime != nil {
                // If we're running, add it to the current running time
                startTime = CFAbsoluteTimeGetCurrent() - newValue
            } else {
                // If we aren't (so if paused or stopped), add it to the saved paused duration (which, if we're stopped, will make us paused instead)
                pausedAtDuration = newValue
            }
            notifyStateObservers()
        }
    }
    
    /// The current state of this stopwatch.
    var state: State {
        get {
            if startTime != nil {
                return .running
            } else if pausedAtDuration != nil {
                return .paused
            }
            return .stopped
        }
        set {
            guard newValue != state else { return }
            switch newValue {
            case .running:
                startTime = CFAbsoluteTimeGetCurrent() - (pausedAtDuration ?? 0)
                pausedAtDuration = nil
            case .paused:
                pausedAtDuration = duration
                startTime = nil
            case .stopped:
                startTime = nil
                pausedAtDuration = nil
            }
            notifyStateObservers()
        }
    }
    
    // MARK: - Control Methods (now only exist for convenience)
    
    func start() {
        state = .running
    }
    
    func reset() {
        state = .stopped
    }
    
    func togglePause() {
        state = state == .paused ? .running : .paused
    }
    
    @objc private func notifyStateObservers() {
        NotificationCenter.default.post(name: Stopwatch.stateChangedNotification, object: self)
    }
}

extension Stopwatch {
    enum State {
        /// The stopwatch was started and is actively counting up.
        case running
        /// The stopwatch was started but paused.
        case paused
        /// The stopwatch has not been started at all (e.g. has a duration equivalent to zero).
        case stopped
    }
}
