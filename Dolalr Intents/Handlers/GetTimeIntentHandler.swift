//
//  GetTimeIntentHandler.swift
//  Dolalr Intents
//
//  Created by Ayden Panhuyzen on 2020-01-15.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import Intents

class GetTimeIntentHandler: NSObject, GetTimeIntentHandling {
    func handle(intent: GetTimeIntent, completion: @escaping (GetTimeIntentResponse) -> Void) {
        let info = ElapsedTimeInfo.current
        let response = GetTimeIntentResponse.success(secondsElapsed: info.secondsElapsed!, formattedAmountEarned: info.amountEarned!.doubleValue.format(using: .currencyFormatter)!)
        response.elapsedTime = info
        
        completion(response)
    }
}

extension ElapsedTimeInfo {
    static var current: ElapsedTimeInfo {
        let duration = Stopwatch.shared.duration
        
        let info = ElapsedTimeInfo(identifier: nil, display: duration.stopwatchFormatted)
        info.secondsElapsed = NSNumber(value: duration)
        info.amountEarned = NSNumber(value: duration * Settings.hourlyRate)
        info.state = .from(stopwatchState: Stopwatch.shared.state)
        return info
    }
}
