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
        stopwatchLabel.font = .monospacedDigitSystemFont(ofSize: 62, weight: .semibold)
        dollarLabel.font = .monospacedDigitSystemFont(ofSize: 32, weight: .semibold)
        
        // Setup
        updateUIState()
    }
    
    @objc private func tick() {
        let duration = Stopwatch.shared.duration ?? 0
        stopwatchLabel.value = duration
        dollarLabel.value = duration / 60 / 60 * Settings.hourlyRate
    }
    
    @IBAction func startStopTapped(_ sender: Any) {
        if Stopwatch.shared.state == .stopped { // Start button
            Stopwatch.shared.start()
        } else { // Resume/Pause button
            Stopwatch.shared.togglePause()
        }
        updateUIState()
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        if Stopwatch.shared.state == .stopped { // Set Rate button
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
    
    private func updateUIState() {
        displayLink?.invalidate()
        
        let state = Stopwatch.shared.state
        
        startPauseButton.setTitle(state != .stopped ? (state == .paused ? "Resume" : "Pause") : "Start", for: .normal)
        
        resetButton.setTitle(state == .stopped ? "Set Rate" : "Reset", for: .normal)
        resetButton.isEnabled = state != .running
        
        tick()
        if state == .running {
            displayLink = CADisplayLink(target: self, selector: #selector(tick))
            displayLink!.add(to: .current, forMode: .common)
        }
    }

}
