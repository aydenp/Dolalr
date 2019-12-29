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
    
    @UserDefault("startTime", defaultValue: nil)
    private var startTime: CFTimeInterval?
    
    @UserDefault("pausedAtDuration", defaultValue: nil)
    private var pausedAtDuration: CFTimeInterval?
    
    // MARK: - State
    
    var duration: CFTimeInterval? {
        if let startTime = startTime {
            return CACurrentMediaTime() - startTime
        } else if let pausedAtDuration = pausedAtDuration {
            return pausedAtDuration
        }
        return nil
    }
    
    enum State {
        case running, paused, stopped
    }
    
    var state: State {
        if startTime != nil {
            return .running
        } else if pausedAtDuration != nil {
            return .paused
        }
        return .stopped
    }
    
    // MARK: - Control Methods
    
    func start() {
        guard state != .running else { return }
        startTime = CACurrentMediaTime()
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
