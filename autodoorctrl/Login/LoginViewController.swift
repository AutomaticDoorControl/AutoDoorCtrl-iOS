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
        }
        LoginAPI.loginUser(username: rcsIDTextField.text ?? "",
                           password: passwordTextField.text ?? "",
                           successHandler: {
                            DispatchQueue.main.async { [weak self] in
                                guard let strongSelf = self else { return }
                                strongSelf.passwordTextField.text = nil
                                strongSelf.rcsIDTextField.text = nil
                                self?.performSegue(withIdentifier: "showSwitchVC", sender: strongSelf)
                            }
        },
                           errorHandler: { [weak self] error in
                            self?.handleError(with: error)
        })
    }
    
    private func handleError(with error: LoginError) {
        switch error {
        case .invalidCredentials:
            SwiftMessagesWrapper.showErrorMessage(title: "Error",
                                                  body: "Incorrect Username or Password")
        case .incompleteCredentials:
            SwiftMessagesWrapper.showErrorMessage(title: "Error",
                                                  body: "Please fill in the username or password")
        case .networkFailure:
            SwiftMessagesWrapper.showErrorMessage(title: "Error",
                                                  body: "No internet connection")
        }
    }
    


}

