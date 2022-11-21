//
//  ViewController.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stopwatchLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    private var rateFormatter: NumberFormatter!
    
    var displayLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUIState), name: Stopwatch.stateChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rateButtonTapped), name: StopwatchUIStateManager.requestSetRateNotification, object: nil)
        NSUbiquitousKeyValueStore.default.synchronize()
        
        // Use monospaced fonts for our digit labels since they change so much (wish I could do this in nib)
        stopwatchLabel.font = .roundedMonospacedDigitSystemFont(ofSize: 62, weight: .semibold)
        dollarLabel.font = .roundedMonospacedDigitSystemFont(ofSize: 32, weight: .semibold)
        
        // Setup UI
        updateUIState()
    }
    
    /// Sets label values (called upon UI state update or, if stopwatch running, every frame)
    @objc private func tick() {
        let duration = Stopwatch.shared.duration
        stopwatchLabel.text = duration.stopwatchFormatted
        let earnings = duration / 60 / 60 * Settings.hourlyRate
        dollarLabel.text = earnings.format(using: .currencyFormatter)

        #if targetEnvironment(macCatalyst)
        if case .running = Stopwatch.shared.state {
            // If > 10, don't show cents/other minor currency unit. Otherwise re-use dollar label text.
            let badgeText = earnings >= 10 ? earnings.format(using: .currencyNoMinorDigitsFormatter) : dollarLabel.text
            dockTile?.perform(Selector(("setBadgeLabel:")), with: badgeText)
        } else {
            dockTile?.perform(Selector(("setBadgeLabel:")), with: nil)
        }
        #endif
    }

    @objc private func rateButtonTapped() {
        self.showRateAlert()
    }

    func showRateAlert(inputText: String? = nil, validationErrorMessage: String? = nil) {
        // Show an alert to ask user for their desired hourly rate
        let messages = [
            validationErrorMessage,
            "Enter your hourly rate in your local currency:"
        ].compactMap { $0 }

        let alert = UIAlertController.createAlert(title: "Set Rate", message: messages.joined(separator: "\n\n"), actions: [.cancel])
        
        alert.addAction(.normal("Set Rate") { _ in
            guard let text = alert.textFields?.first?.text else { return }
            if let newRate = Double.from(formattedString: text, using: .rateCurrencyFormatter) {
                Settings.hourlyRate = newRate
            } else {
                self.showRateAlert(
                    inputText: text,
                    validationErrorMessage: "Invalid amount. Please enter in the format: \"\(1234.56.format(using: .rateCurrencyFormatter)!)\"."
                )
            }
        })
        
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = Double.zero.format(using: .rateCurrencyFormatter)
            textField.text = inputText ?? Settings.hourlyRate.format(using: .rateCurrencyFormatter)
        }
        
        present(alert, animated: true, completion: nil)
    }

    #if targetEnvironment(macCatalyst)
    lazy var dockTile = { () -> NSObject? in
        // i want to vomit
        guard let nsAppClass = NSClassFromString("NSApplication") as? NSObjectProtocol,
            let nsApp = nsAppClass.perform(#selector(getter: UIApplication.shared))?.takeRetainedValue() as? NSObject else { return nil }
        return nsApp.value(forKey: "dockTile") as? NSObject
    }()
    #endif
    
    /// Update the UI state to match that of the stopwatch
    @objc private func updateUIState() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.updateUIState()
            }
            return
        }

        // Invalidate the old display link
        displayLink?.invalidate()

        buttonTemplates = StopwatchUIStateManager.shared.getButtonTemplates()

        // Update stopwatch time
        tick()
        if Stopwatch.shared.state == .running {
            // If the stopwatch is running, setup a display link to update the labels on every frame
            displayLink = CADisplayLink(target: self, selector: #selector(tick))
            displayLink!.add(to: .current, forMode: .common)
        }
    }
    
    private(set) var buttonTemplates: StopwatchUIStateManager.ButtonTemplateSet? {
        didSet {
            guard let (primary, secondary) = buttonTemplates else { return }
            func setup(button: UIButton, for template: StopwatchUIStateManager.ButtonTemplate) {
                button.removeTarget(nil, action: nil, for: .touchUpInside)
                button.setTitle(template.title, for: .normal)
                button.isEnabled = template.isEnabled
                button.addTarget(template, action: #selector(template.performAction), for: .touchUpInside)
            }
            setup(button: startPauseButton, for: primary)
            setup(button: resetButton, for: secondary)
            
            #if targetEnvironment(macCatalyst)
            self.touchBar = nil
            #endif
        }
    }
}
