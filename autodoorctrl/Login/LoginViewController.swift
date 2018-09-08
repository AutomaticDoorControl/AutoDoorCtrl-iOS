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
                                strongSelf.passwordTextField.text = nil
                                strongSelf.enableUI()
                                strongSelf.performSegue(withIdentifier: "showSwitchVC", sender: strongSelf)
                            }
        },
                           errorHandler: { [weak self] error in
                            self?.enableUI()
                            self?.handleError(with: error)
        })
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
        loginButton.layer.cornerRadius = 10.0
        loginButton.clipsToBounds = true
        passwordTextField.setBottomBorder()
        rcsIDTextField.setBottomBorder()
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
        versionLabel.text = "v\(version)"
    }
    
    private func disableUI() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        loginButton.setTitle("Logging in", for: .normal)
    }
    
    private func enableUI () {
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
        loginButton.setTitle("Log in", for: .normal)
    }
}

