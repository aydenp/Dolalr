//
//  RoundedButton.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        contentEdgeInsets = .init(top: 16, left: 20, bottom: 16, right: 20)
        layer.cornerRadius = 12
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        setupColours()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        setupColours()
    }
    
    func setupColours() {
        setTitleColor(tintColor, for: .normal)
        backgroundColor = tintColor.withAlphaComponent(0.1)
    }
    
    override var isHighlighted: Bool {
        didSet { updateState() }
    }
    
    override var isEnabled: Bool {
        didSet { updateState() }
    }
    
    private func updateState() {
        setupColours()
        UIView.animate(withDuration: 0.1) {
            self.alpha = self.isEnabled ? (self.isHighlighted ? 0.7 : 1) : 0.4
        }
    }
    
}
