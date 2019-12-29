//
//  StopwatchLabel.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

class StopwatchFormattingLabel: DoubleFormattingLabelBase {
    override func populateValue() {
        self.text = value.stopwatchFormatted
    }
}
