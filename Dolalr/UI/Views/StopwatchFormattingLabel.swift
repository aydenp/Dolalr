//
//  StopwatchLabel.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

/// Format a double value like a stopwatch.
class StopwatchFormattingLabel: DoubleFormattingLabelBase {
    override var formattedValue: String? {
        return value.stopwatchFormatted
    }
}
