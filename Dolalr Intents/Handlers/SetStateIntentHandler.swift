//
//  SetStateIntentHandler.swift
//  Dolalr Intents
//
//  Created by Ayden Panhuyzen on 2020-01-15.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import Intents

class SetStateIntentHandler: NSObject, SetStateIntentHandling {
    func handle(intent: SetStateIntent, completion: @escaping (SetStateIntentResponse) -> Void) {
        Stopwatch.shared.state = intent.state.stopwatchState!
        completion(.init(code: .success, userActivity: nil))
    }
    
    func resolveState(for intent: SetStateIntent, with completion: @escaping (IntentStateResolutionResult) -> Void) {
        guard intent.state.stopwatchState != nil else {
            completion(.needsValue())
            return
        }
        completion(.success(with: intent.state))
    }
}
