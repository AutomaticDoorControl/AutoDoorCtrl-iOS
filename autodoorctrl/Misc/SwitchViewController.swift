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
    
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    fileprivate var isOn = false
    fileprivate let orangeColor = UIColor(red: 244/255, green: 176/255, blue: 62/255, alpha: 1)
    fileprivate let greenColor = UIColor(red: 142/255, green: 202/255, blue: 67/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        BLEManager.current.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IBActions
    
    @IBAction func dismiss(_ sender: UIButton) {
        BLEManager.current.disconnect()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func lockOrUnlock(_ sender: UITapGestureRecognizer) {
        hapticFeedback.impactOccurred()
        BLEManager.current.send(string: Constants.toggleCommand)
    }
}

extension SwitchViewController: BLEManagerDelegate {
    // MARK: BLEManagerDelegate
    func didReceiveError(error: BLEError?) {
        dismiss(animated: true) {
            error?.showErrorMessage()
        }
    }
    
    func didReceiveMessage(message: String) {
        if message == Constants.IncomingCommands.onCommand {
            isOn = true
            statusLabel.text = NSLocalizedString("OpenDoorTitle", comment: "")
        } else if message == Constants.IncomingCommands.offCommand {
            isOn = false
            statusLabel.text = NSLocalizedString("CloseDoorTitle", comment: "")
        }
        
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.backgroundColor = (self?.isOn ?? false)
                ? self?.greenColor
                : self?.orangeColor
            }, completion: nil)
    }
}
