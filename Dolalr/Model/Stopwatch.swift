//
//  Stopwatch.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

class Stopwatch {
    static let shared = Stopwatch()
    
    // MARK: - Values (persistent)
    
    /// If this stopwatch is actively running, the time it was started at.
    @UserDefault("startTime", defaultValue: nil)
    private var startTime: CFTimeInterval?
    
    /// If this stopwatch was paused, the duration at the time it was paused.
    @UserDefault("pausedAtDuration", defaultValue: nil)
    private var pausedAtDuration: CFTimeInterval?
    
    // MARK: - State
    
    /// The current duration of this stopwatch, if running or paused.
    var duration: CFTimeInterval? {
        if let startTime = startTime {
            return CACurrentMediaTime() - startTime
        } else if let pausedAtDuration = pausedAtDuration {
            return pausedAtDuration
        }
        return nil
    }
    
    enum State {
        /// The stopwatch was started and is actively counting up.
        case running
        /// The stopwatch was started but paused.
        case paused
        /// The stopwatch has not been started at all.
        case stopped
    }
    
    /// The current state of this stopwatch.
    var state: State {
        if startTime != nil {
            return .running
        } else if pausedAtDuration != nil {
            return .paused
        }
        return .stopped
    }
    
    // MARK: - Control Methods
    
    func start(at duration: CFTimeInterval = 0) {
        guard state != .running else { return }
        startTime = CACurrentMediaTime() - duration
    }
    
    func reset() {
        startTime = nil
        pausedAtDuration = nil
    }
    
    func togglePause() {
        if state == .paused {
            _resume()
        } else {
            _pause()
        }
    }
    
    private func _pause() {
        pausedAtDuration = duration
        startTime = nil
    }
    
    private func _resume() {
        guard let pausedAtDuration = pausedAtDuration else { return }
        startTime = CACurrentMediaTime() - pausedAtDuration
        self.pausedAtDuration = nil
    }
}
