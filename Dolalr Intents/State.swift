//
//  IntentState.swift
//  Dolalr Intents
//
//  Created by Ayden Panhuyzen on 2020-01-15.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import Intents

extension IntentState {
    static func from(stopwatchState: Stopwatch.State) -> IntentState {
        switch stopwatchState {
        case .running: return .running
        case .paused: return .paused
        case .stopped: return .stopped
        }
    }
    
    var stopwatchState: Stopwatch.State? {
        switch self {
        case .running: return .running
        case .paused: return .paused
        case .stopped: return .stopped
        default: return nil
        }
    }
}
