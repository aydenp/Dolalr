//
//  CurrencyFormattingLabel.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

/// Format a double value as currency.
class CurrencyFormattingLabel: DoubleFormattingLabelBase {
    var formatter = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    override func populateValue() {
        self.text = formatter.string(from: NSNumber(value: value))
    }
}
