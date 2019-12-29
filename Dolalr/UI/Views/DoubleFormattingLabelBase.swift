//
//  DoubleFormattingLabelBase.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

/// A label class that automatically formats a provided double value in `populateValue()`.
class DoubleFormattingLabelBase: UILabel {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        populateValue()
    }
    
    public var value: Double = 0 {
        didSet { populateValue() }
    }
    
    open func populateValue() {
        fatalError("Please override DoubleFormattingLabelBase.populateValue() in your subclass.")
    }
}
