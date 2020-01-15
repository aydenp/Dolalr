//
//  SetRateIntentHandler.swift
//  Dolalr Intents
//
//  Created by Ayden Panhuyzen on 2020-01-15.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import Intents

class SetRateIntentHandler: NSObject, SetRateIntentHandling {
    func handle(intent: SetRateIntent, completion: @escaping (SetRateIntentResponse) -> Void) {
        // Make sure the stopwatch is stopped
        guard Stopwatch.shared.state == .stopped else {
            completion(.init(code: .notStopped, userActivity: nil))
            return
        }
        
        // Get hourly rate
        guard let hourlyRate = intent.hourlyRate?.doubleValue else {
            completion(.init(code: .failure, userActivity: nil))
            return
        }
        
        Settings.hourlyRate = hourlyRate
        completion(.init(code: .success, userActivity: nil))
    }
    
    func resolveHourlyRate(for intent: SetRateIntent, with completion: @escaping (SetRateHourlyRateResolutionResult) -> Void) {
        guard let hourlyRate = intent.hourlyRate?.doubleValue else {
            completion(.needsValue())
            return
        }
        guard hourlyRate > 0 else {
            completion(.unsupported(forReason: .negativeNumbersNotSupported))
            return
        }
        completion(.success(with: hourlyRate))
    }
}
