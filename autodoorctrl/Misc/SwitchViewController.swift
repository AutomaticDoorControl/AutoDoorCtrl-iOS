//
//  SwitchViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/7/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var signalStrengthIndicator: UIImageView!
    @IBOutlet weak var closingTimerLabel: UILabel!
    
    fileprivate var isOn = false
    fileprivate let orangeColor = UIColor(red: 254/255, green: 179/255, blue: 54/255, alpha: 1)
    fileprivate let greenColor = UIColor(red: 142/255, green: 202/255, blue: 67/255, alpha: 1)
    fileprivate var signalStrengthTimer: Timer?
    fileprivate var closingTimer: Timer?
    fileprivate var countdown: Int = Constants.doorClosingTime

    override func viewDidLoad() {
        super.viewDidLoad()
        BLEManager.current.delegate = self
        
        signalStrengthTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            BLEManager.current.readSignalStrength()
        }
        signalStrengthTimer?.tolerance = 1.0
        closingTimerLabel.isHidden = true
        
        statusLabel.accessibilityHint = NSLocalizedString("openDoorHint", comment: "")
        configureSignalStrengthAccessiblity()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IBActions
    
    @IBAction func dismiss(_ sender: UIButton) {
        BLEManager.current.disconnect()
        signalStrengthTimer?.invalidate()
        closingTimer?.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func lockOrUnlock(_ sender: UITapGestureRecognizer) {
        BLEManager.current.send(string: Constants.toggleCommand)
    }
    
    /*
    func showProcessingState() {
        statusLabel.text = isOn ? NSLocalizedString("ClosingDoorTitle", comment: "")
            : NSLocalizedString("OpeningDoorTitle", comment: "")
        view.isUserInteractionEnabled = false
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.backgroundColor = UIColor.gray
        }, completion: nil)
    }
    */
    
    // MARK: - Accessibility
    func configureSignalStrengthAccessiblity() {
        signalStrengthIndicator.isAccessibilityElement = true
        signalStrengthIndicator.accessibilityTraits = .none
        signalStrengthIndicator.accessibilityLabel =
            NSLocalizedString("signalStrengthHint", comment: "")
        signalStrengthIndicator.accessibilityValue = BLESignalStrength.amazing.strengthDescription
    }
    
    func processDoorClosingSubtitle(from countdown: Int) -> String {
        return [
            NSLocalizedString("closingAnnouncement", comment: ""),
            "\(countdown)",
            NSLocalizedString("secondTitle", comment: "")
        ].joined(separator: " ")
    }
}

extension SwitchViewController: BLEManagerDelegate {
    // MARK: BLEManagerDelegate
    func didReceiveError(error: BLEError?) {
        signalStrengthTimer?.invalidate()
        closingTimer?.invalidate()
        view.isUserInteractionEnabled = true
        dismiss(animated: true) {
            error?.showErrorMessage()
        }
    }
    
    func didReceiveMessage(message: String) {
        Haptic.current.generateHardHaptic()
        if message == Constants.IncomingCommands.onCommand {
            isOn = true
            closingTimerLabel.isHidden = false
            view.isUserInteractionEnabled = false
            statusLabel.text = NSLocalizedString("OpenDoorTitle", comment: "")
            closingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let strongSelf = self else { return }
                strongSelf.closingTimerLabel.text =
                    strongSelf.processDoorClosingSubtitle(from: strongSelf.countdown)
                
                strongSelf.countdown -= 1
                if strongSelf.countdown % 5 == 0 {
                    let countdownAnnouncement = strongSelf.processDoorClosingSubtitle(from: strongSelf.countdown)
                    UIAccessibility.post(notification: .announcement, argument: countdownAnnouncement)
                }
                Haptic.current.generateLightHaptic()
            }
        } else if message == Constants.IncomingCommands.offCommand {
            isOn = false
            closingTimerLabel.isHidden = true
            view.isUserInteractionEnabled = true
            statusLabel.text = NSLocalizedString("CloseDoorTitle", comment: "")
            closingTimer?.invalidate()
            closingTimerLabel.text = "Closing in \(Constants.doorClosingTime)s"
            countdown = Constants.doorClosingTime
            UIAccessibility.post(notification: .announcement,
                                 argument: NSLocalizedString("doorClosedAnnouncement", comment: ""))
        }
        
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            self?.view.backgroundColor = strongSelf.isOn ? strongSelf.greenColor : strongSelf.orangeColor
        }, completion: nil)
    }
    
    func didReceiveRSSIReading(reading: BLESignalStrength) {
        signalStrengthIndicator.image = reading.strengthImage
        signalStrengthIndicator.accessibilityValue = reading.strengthDescription
    }
}
