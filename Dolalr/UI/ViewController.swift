//
//  ViewController.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stopwatchLabel: StopwatchFormattingLabel!
    @IBOutlet weak var dollarLabel: CurrencyFormattingLabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var displayLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use monospaced fonts for our digit labels since they change so much (wish I could do this in nib)
        stopwatchLabel.font = .roundedMonospacedDigitSystemFont(ofSize: 62, weight: .semibold)
        dollarLabel.font = .roundedMonospacedDigitSystemFont(ofSize: 32, weight: .semibold)
        
        // Setup UI
        updateUIState()
    }
    
    /// Sets label values (called upon UI state update or, if stopwatch running, every frame)
    @objc private func tick() {
        let duration = Stopwatch.shared.duration ?? 0
        stopwatchLabel.value = duration
        dollarLabel.value = duration / 60 / 60 * Settings.hourlyRate
    }
    
    /// Tapped the start/resume/pause button
    @IBAction func startStopTapped(_ sender: Any) {
        if Stopwatch.shared.state == .stopped { // Start button
            Stopwatch.shared.start()
        } else { // Resume/Pause button
            Stopwatch.shared.togglePause()
        }
        updateUIState()
    }
    
    /// Tapped the reset/set rate button
    @IBAction func resetTapped(_ sender: Any) {
        if Stopwatch.shared.state == .stopped { // Set Rate button
            // Show an alert to ask user for their desired hourly rate
            let alert = UIAlertController.createAlert(title: "Set Rate", message: "Enter your hourly rate in your local currency", actions: [.cancel])
            
            alert.addAction(.normal("Set Rate") { _ in
                guard let text = alert.textFields?.first?.text, let newRate = Double(text) else { return }
                Settings.hourlyRate = newRate
            })
            
            alert.addTextField { (textField) in
                textField.keyboardType = .decimalPad
                textField.placeholder = "0.00"
                textField.text = String(Settings.hourlyRate)
            }
            
            present(alert, animated: true, completion: nil)
        } else { // Reset button
            Stopwatch.shared.reset()
        }
        updateUIState()
    }
    
    /// Update the UI state to match that of the stopwatch
    private func updateUIState() {
        // Invalidate the old display link
        displayLink?.invalidate()
        
        let state = Stopwatch.shared.state
        
        // Setup button states
        startPauseButton.setTitle(state != .stopped ? (state == .paused ? "Resume" : "Pause") : "Start", for: .normal)
        
        resetButton.setTitle(state == .stopped ? "Set Rate" : "Reset", for: .normal)
        resetButton.isEnabled = state != .running
        
        // Update stopwatch time
        tick()
        if state == .running {
            // If the stopwatch is running, setup a display link to update the labels on every frame
            displayLink = CADisplayLink(target: self, selector: #selector(tick))
            displayLink!.add(to: .current, forMode: .common)
        }
    }

}

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
        Stopwatch.shared.start(at: (58 * 60) + 32.42)
        
        updateUIState()
        displayLink?.invalidate()
        
        if #available(iOS 13.0, *) {
            view.window?.overrideUserInterfaceStyle = .light
        }
    }
    
    @objc func test_2() {
        Stopwatch.shared.reset()
        updateUIState()
    }
    
    @objc func test_3() {
        Settings.hourlyRate = 120
        Stopwatch.shared.reset()
        Stopwatch.shared.start(at: (2 * 60 * 60) + (19 * 60) + 24.45)
        Stopwatch.shared.togglePause()
        updateUIState()
        if #available(iOS 13.0, *) {
            view.window?.overrideUserInterfaceStyle = .dark
        }
    }
}
#endif
