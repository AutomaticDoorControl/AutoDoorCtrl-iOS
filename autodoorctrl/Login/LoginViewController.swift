//
//  LoginViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/7/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import JLActivityIndicator

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var rcsIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var biometricsButton: UIButton!
    @IBOutlet weak var resetBioButton: UIButton!
    
    private let rcsIDTextFieldTag = 1
    private let passwordTextFieldTag = 2
    
    lazy var activityIndicator: JLActivityIndicator = {
        let ai = JLActivityIndicator(on: view, mode: .path)
        ai.enableBackDrop = true
        return ai
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rcsIDTextField.delegate = self
        passwordTextField.delegate = self
        
        rcsIDTextField.tag = rcsIDTextFieldTag
        passwordTextField.tag = passwordTextFieldTag
        passwordTextField.isSecureTextEntry = true
        
        rcsIDTextField.textColor = UIColor.systemGray
        passwordTextField.textColor = UIColor.systemGray
        
        rcsIDTextField.accessibilityLabel = "RCSID"
        passwordTextField.accessibilityLabel = NSLocalizedString("PasswordTitle", comment: "")
        biometricsButton.accessibilityLabel = NSLocalizedString("biometricsButtonTitle", comment: "")
        biometricsButton.accessibilityHint = NSLocalizedString("biometricsHint", comment: "")
        
        configureUI()
        
        #if DEBUG
            rcsIDTextField.text = "test"
            passwordTextField.text = "test"
        #endif
        
        loginUserWithBiometrics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let shouldHideBiometricButton = !BiometricsController.isBiometricAvailable() || UserDefaults.isFirstLogin()
        biometricsButton.isHidden = shouldHideBiometricButton
        if BiometricsController.biometricMode() == "Face ID" {
            biometricsButton.setImage(UIImage(named: "faceIDIcon"), for: .normal)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if let previousTraitCollection = previousTraitCollection, traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle {
                passwordTextField.setBottomBorder()
                rcsIDTextField.setBottomBorder()
            }
        }
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
        LoginAPI.loginUser(
            username: rcsIDTextField.text ?? "",
            password: passwordTextField.text ?? "",
            successHandler:
        {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                
                let completion: (Bool) -> Void = { showOnboarding in
                    strongSelf.passwordTextField.text = nil
                    strongSelf.enableUI()
                    if showOnboarding {
                        let extraInfo = ExtraInformationViewController()
                        extraInfo.didDismiss = {
                            strongSelf.performSegue(withIdentifier: "showMaps", sender: strongSelf)
                        }
                        let vc = PageViewController(dataSets: SplashScreenDataSets().dataSets, actionVC: extraInfo)
                        vc.modalPresentationStyle = .fullScreen
                        strongSelf.present(vc, animated: true, completion: nil)
                    } else {
                        strongSelf.performSegue(withIdentifier: "showMaps", sender: strongSelf)
                    }
                }
                
                if UserDefaults.isFirstLogin() && BiometricsController.isBiometricAvailable() {
                    strongSelf.showBiometricsAlert(withAgreedHandler: { completion(true) },
                                                   withDisagreedHandler: { completion(true) },
                                                   shouldSavePassword: true)
                    UserDefaults.setFirstLogin()
                } else {
                    if BiometricsController.isUserAgreedToBiometrics() && !UserDefaults.isLoginSaved() {
                        self?.saveLoginCredentials()
                    }
                    completion(false)
                }
            }
        }, errorHandler: { [weak self] error in
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
    
    @IBAction func showOptionsMenu(_ sender: Any) {
        if let button = sender as? UIButton {
            handleLoginOptions(with: button)
        }
    }
    
    // MARK: - "Private"
    
    private func handleError(with error: NetworkingError) {
        error.handleError()
    }
    
    private func configureUI () {
        loginButton.addRoundedCorner()
        passwordTextField.setBottomBorder()
        rcsIDTextField.setBottomBorder()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        versionLabel.text = "v\(version)"
        
        if !BiometricsController.isUserAgreedToBiometrics() { resetBioButton.isHidden = true }
    }
    
    func disableUI() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        loginButton.setTitle(NSLocalizedString("LoggingInTitle", comment: ""), for: .normal)
        resetBioButton.isEnabled = false
        resetBioButton.alpha = 0.5
        activityIndicator.start()
    }
    
    func enableUI () {
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
        loginButton.setTitle(NSLocalizedString("LogInTitle", comment: ""), for: .normal)
        resetBioButton.isEnabled = true
        resetBioButton.alpha = 1
        activityIndicator.stop()
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
                                      message: String(format: NSLocalizedString("BioAlertTitle", comment: ""), biometricString),
                                      preferredStyle: .alert)
        let agreedAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { [weak self] _ in
            UserDefaults.setBiometricAgreement()
            self?.resetBioButton.isHidden = false
            if shouldSavePassword {
                self?.saveLoginCredentials()
                agreedHandler()
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel) { _ in disagreedHandler() }
        
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

