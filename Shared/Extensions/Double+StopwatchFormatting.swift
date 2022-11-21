//
//  Double+StopwatchFormatting.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static let currencyFormatter = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    static let currencyNoMinorDigitsFormatter = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    static let rateCurrencyFormatter = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.groupingSeparator = ""
        return formatter
    }()
}

extension Double {
    var stopwatchFormatted: String {
        let frac = Int(self * 100) % 100
        let sec = Int(self) % 60
        let min = Int(self) / 60 % 60
        let hour = Int(self) / 60 / 60
        
        if hour > 0 {
            // has hours, format as: HH:mm:ss
            return String(format: "%0d:%02d:%02d", hour, min, sec)
        }
        // otherwise: mm:ss.ms
        return String(format: "%02d:%02d.%02d", min, sec, frac)
    }
    
    func format(using formatter: NumberFormatter) -> String? {
        return formatter.string(from: NSNumber(value: self))
    }
    
    static func from(formattedString string: String, using formatter: NumberFormatter) -> Double? {
        return formatter.number(from: string)?.doubleValue
    }
}
