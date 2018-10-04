//
//  LoginViewController+Options.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/29/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController {
    
    func handleLoginOptions(with button: UIButton) {
        let username = self.rcsIDTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        
        let adminLoginAction = UIAlertAction(title: NSLocalizedString("AdminLoginTitle", comment: ""),
                                             style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            LoginAPI.loginAdmin(username: username, password: password, successHandler: {
                strongSelf.performSegue(withIdentifier: "showMaps", sender: strongSelf)
            }, errorHandler: { $0.handleError() })
        }
        
        let bioTitle = String(format: NSLocalizedString("ResetBioTitle", comment: ""), BiometricsController.biometricMode())
        let resetBioAction = UIAlertAction(title: bioTitle, style: .destructive) { [weak self] _ in
            self?.resetBiometricFunctions()
        }
        
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: NSLocalizedString("OptionsTitle", comment: ""),
                                                message: nil, preferredStyle: .actionSheet)
        alertController.addAction(adminLoginAction)
        alertController.addAction(resetBioAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = UIColor.red
        
        alertController.popoverPresentationController?.sourceView = button
        alertController.popoverPresentationController?.sourceRect = button.bounds
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func resetBiometricFunctions() {
        let bioString = BiometricsController.biometricMode()
        let resetBioAlert = UIAlertController(title: String(format: NSLocalizedString("ResetBioTitle", comment: ""), bioString),
                                              message: String(format: NSLocalizedString("ResetBioMessage", comment: ""), bioString),
                                              preferredStyle: .alert)
        resetBioAlert.view.tintColor = UIColor.red
        resetBioAlert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { [weak self] _ in
            BiometricsController.resetBiometrics()
            self?.resetBioButton.isHidden = true
            self?.biometricsButton.isHidden = true
            UserDefaults.resetFirstLogin()
        })
        resetBioAlert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        present(resetBioAlert, animated: true, completion: nil)
    }
    
}
