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
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    var isOn = false
    private let orangeColor = UIColor(red: 244/255, green: 176/255, blue: 62/255, alpha: 1)
    private let greenColor = UIColor(red: 142/255, green: 202/255, blue: 67/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func lockOrUnlock(_ sender: UITapGestureRecognizer) {
        hapticFeedback.impactOccurred()
        if isOn {
            isOn = false
            statusLabel.text = NSLocalizedString("CloseDoorTitle", comment: "")
        } else {
            isOn = true
            statusLabel.text = NSLocalizedString("OpenDoorTitle", comment: "")
        }
        
        UIView.transition(with: view,
                          duration: 0.5,
                          options: .curveEaseInOut,
                          animations: { [weak self] in
                            self?.view.backgroundColor = (self?.isOn ?? false)
                                ? self?.greenColor
                                : self?.orangeColor
            },
                          completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
