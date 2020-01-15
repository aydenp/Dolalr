//
//  ViewController+SimulatorScreenshotRigging.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2020-01-09.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import UIKit

// MARK: - Screenshot State keys for Simulator
#if targetEnvironment(simulator)
extension ViewController {
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "1", modifierFlags: [], action: #selector(test_1)),
            UIKeyCommand(input: "2", modifierFlags: [], action: #selector(test_2)),
            UIKeyCommand(input: "3", modifierFlags: [], action: #selector(test_3))
        ]
    }
    
    @objc func test_1() {
        Settings.hourlyRate = 120
        Stopwatch.shared.reset()
        Stopwatch.shared.start()
        Stopwatch.shared.duration = (58 * 60) + 32.42
        
        displayLink?.invalidate()
        
        if #available(iOS 13.0, *) {
            view.window?.overrideUserInterfaceStyle = .light
        }
    }
    
    @objc func test_2() {
        Stopwatch.shared.reset()
    }
    
    @objc func test_3() {
        Stopwatch.shared.reset()
        Stopwatch.shared.duration = (2 * 60 * 60) + (19 * 60) + 24.45
        
        if #available(iOS 13.0, *) {
            view.window?.overrideUserInterfaceStyle = .dark
        }
    }
}
#endif
