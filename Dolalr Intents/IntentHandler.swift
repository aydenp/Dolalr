//
//  IntentHandler.swift
//  Dolalr Intents
//
//  Created by Ayden Panhuyzen on 2020-01-09.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        if intent is SetStateIntent {
            return SetStateIntentHandler()
        } else if intent is SetRateIntent {
            return SetRateIntentHandler()
        } else if intent is GetTimeIntent {
            return GetTimeIntentHandler()
        }
        fatalError("I have no idea how to handle that intent.")
    }
}
