//
//  Settings.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import Foundation

struct Settings {
    @UbiquitousStore("hourlyRate", defaultValue: 0)
    static var hourlyRate: Double
}
