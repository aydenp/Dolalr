//
//  StopwatchUIStateManager.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2020-01-09.
//  Copyright © 2020 Ayden Panhuyzen. All rights reserved.
//

import Foundation

class StopwatchUIStateManager {
    static let requestSetRateNotification = Notification.Name(rawValue: "StopwatchUIStateManager.RequestSetRateNotification.Name")
    static let shared = StopwatchUIStateManager()
    
    typealias ButtonTemplateSet = (primary: ButtonTemplate, secondary: ButtonTemplate)
    
    func getButtonTemplates() -> ButtonTemplateSet {
        let state = Stopwatch.shared.state
        
        return (
            primary: ButtonTemplate(title: state != .stopped ? (state == .paused ? "Resume" : "Pause") : "Start", action: {
                if Stopwatch.shared.state == .stopped { // Start button
                    Stopwatch.shared.start()
                } else { // Resume/Pause button
                    Stopwatch.shared.togglePause()
                }
            }),
            secondary: ButtonTemplate(title: state == .stopped ? "Set Rate" : "Reset", action: state != .running ? {
                if Stopwatch.shared.state == .stopped { // Set Rate button
                    NotificationCenter.default.post(name: StopwatchUIStateManager.requestSetRateNotification, object: nil)
                } else { // Reset button
                    Stopwatch.shared.reset()
                }
            } : nil)
        )
    }
    
    class ButtonTemplate {
        let title: String
        let action: (() -> ())?
        
        fileprivate init(title: String, action: (() -> ())?) {
            self.title = title
            self.action = action
        }
        
        var isEnabled: Bool {
            return action != nil
        }
        
        @objc func performAction() {
            action?()
        }
    }
}
