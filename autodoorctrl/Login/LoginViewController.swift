//
//  LoginViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/7/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var rcsIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var biometricsButton: UIButton!
    @IBOutlet weak var resetBioButton: UIButton!
    
    private let rcsIDTextFieldTag = 1
    private let passwordTextFieldTag = 2
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rcsIDTextField.delegate = self
        passwordTextField.delegate = self
        
        rcsIDTextField.tag = rcsIDTextFieldTag
        passwordTextField.tag = passwordTextFieldTag
        passwordTextField.isSecureTextEntry = true
        
        configureUI()
        
        #if DEBUG
            rcsIDTextField.text = "abc"
            passwordTextField.text = "abc"
        #endif
        
        loginUserWithBiometrics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let shouldHideBiometricButton = !BiometricsController.isBiometricAvailable() || UserDefaults.isFirstLogin()
        biometricsButton.isHidden = shouldHideBiometricButton
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if passwordTextField.text?.isEmpty ?? false || rcsIDTextField.text?.isEmpty ?? false {
            handleError(with: .incompleteCredentials)
            return
        }
        disableUI()
        LoginAPI.loginUser(username: rcsIDTextField.text ?? "",
                           password: passwordTextField.text ?? "",
                           successHandler: {
                            DispatchQueue.main.async { [weak self] in
                                guard let strongSelf = self else { return }
                                
                                let completion = {
                                    strongSelf.passwordTextField.text = nil
                                    strongSelf.enableUI()
                                    strongSelf.performSegue(withIdentifier: "showMaps", sender: strongSelf)
                                }
                                
                                if UserDefaults.isFirstLogin() && BiometricsController.isBiometricAvailable() {
                                    strongSelf.showBiometricsAlert(withAgreedHandler: { completion() },
                                                                   withDisagreedHandler: { completion() },
                                                                   shouldSavePassword: true)
                                    UserDefaults.setFirstLogin()
                                } else {
                                    if BiometricsController.isUserAgreedToBiometrics() && !UserDefaults.isLoginSaved() {
                                        self?.saveLoginCredentials()
                                    }
                                    completion()
                                }
                            }
        },
                           errorHandler: { [weak self] error in
                            self?.enableUI()
                            self?.handleError(with: error)
        })
    }
    
    @IBAction func biometricButtonTapped(_ sender: UIButton) {
        if !BiometricsController.isUserAgreedToBiometrics() && !UserDefaults.isLoginSaved() {
            showBiometricsAlert()
        } else if !BiometricsController.isUserAgreedToBiometrics() {
            showBiometricsAlert(withAgreedHandler: { [weak self] in self?.loginUserWithBiometrics() },
                                shouldSavePassword: true)
        } else {
            loginUserWithBiometrics()
        }
    }
    
    @IBAction func resetBiometrics(_ sender: Any) {
        let bioString = BiometricsController.biometricMode()
        let resetBioAlert = UIAlertController(title: "Reset \(bioString)?",
                                              message: "This will remove all the \(bioString) login credentials.",
                                              preferredStyle: .alert)
        resetBioAlert.view.tintColor = UIColor.red
        resetBioAlert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            BiometricsController.resetBiometrics()
            self?.resetBioButton.isHidden = true
            self?.biometricsButton.isHidden = true
            UserDefaults.resetFirstLogin()
        })
        resetBioAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(resetBioAlert, animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private func handleError(with error: LoginError) {
        switch error {
        case .invalidCredentials:
            SwiftMessagesWrapper.showErrorMessage(title: "Error",
                                                  body: "Incorrect username or password")
        case .incompleteCredentials:
            SwiftMessagesWrapper.showErrorMessage(title: "Error",
                                                  body: "Please fill in the username or password")
        case .networkFailure:
            SwiftMessagesWrapper.showErrorMessage(title: "Error",
                                                  body: "No internet connection")
        }
    }
    
    private func configureUI () {
        loginButton.addRoundedCorner()
        passwordTextField.setBottomBorder()
        rcsIDTextField.setBottomBorder()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        versionLabel.text = "v\(version)"
        
        if !BiometricsController.isUserAgreedToBiometrics() { resetBioButton.isHidden = true }
    }
    
    private func disableUI() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        loginButton.setTitle("Logging in", for: .normal)
        resetBioButton.isEnabled = false
        resetBioButton.alpha = 0.5
    }
    
    private func enableUI () {
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
        loginButton.setTitle("Log in", for: .normal)
        resetBioButton.isEnabled = true
        resetBioButton.alpha = 1
    }
    
    // MARK: - Private Methods: Biometrics
    
    /** Shows a biometric alert asking if the user want to use the biometric login feature.
     - note: Only save the passwords when they are correct
     */
    private func showBiometricsAlert(withAgreedHandler agreedHandler: @escaping () -> Void = { },
                                     withDisagreedHandler disagreedHandler: @escaping () -> Void = { },
                                     shouldSavePassword: Bool = false) {
        let biometricString = BiometricsController.biometricMode()
        let alert = UIAlertController(title: biometricString,
                                      message: "Use \(biometricString) for faster future logins?",
                                      preferredStyle: .alert)
        let agreedAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            UserDefaults.setBiometricAgreement()
            self?.resetBioButton.isHidden = false
            if shouldSavePassword {
                self?.saveLoginCredentials()
                agreedHandler()
            }
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in disagreedHandler() }
        
        alert.addAction(agreedAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveLoginCredentials() {
        try? KeychainOperations.savePassword(self.passwordTextField.text ?? "",
                                             attachedToRCSID: self.rcsIDTextField.text ?? "")
        UserDefaults.saveRCSID(with: self.rcsIDTextField.text ?? "")
    }
    
    private func loginUserWithBiometrics() {
        if BiometricsController.isUserAgreedToBiometrics() {
            BiometricsController.loginWithBiometrics(onSuccess: { [weak self] in
                guard let strongSelf = self else { return }
                let rcsID = UserDefaults.rcsID()
                let password = (try? KeychainOperations.retrievePassword(matching: rcsID)) ?? ""
                strongSelf.disableUI()
                LoginAPI.loginUser(username: rcsID, password: password,
                                   successHandler: {
                                    strongSelf.enableUI()
                                    strongSelf.performSegue(withIdentifier: "showMaps", sender: strongSelf)
                    },
                                   errorHandler: { error in
                                    strongSelf.enableUI()
                                    strongSelf.handleError(with: error)
                })
            })
        }
    }
}

