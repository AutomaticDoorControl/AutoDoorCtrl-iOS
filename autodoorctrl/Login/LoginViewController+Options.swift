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
    
    func handleLoginOptions() {
        let username = self.rcsIDTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        
        let adminLoginAction = UIAlertAction(title: NSLocalizedString("AdminLoginTitle", comment: ""),
                                             style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            LoginAPI.loginAdmin(username: username, password: password, successHandler: {
                strongSelf.performSegue(withIdentifier: "showMaps", sender: strongSelf)
            }, errorHandler: { error in
                strongSelf.handleError(with: error)
            })
        }
        
        let showActiveStudentsAction = UIAlertAction(title: NSLocalizedString("ShowActiveTitle", comment: ""),
                                                     style: .default) { [weak self] _ in
            ServicesAPI.showActiveUser(successHandler: { students in
                SwiftMessagesWrapper.showGenericMessage(title: NSLocalizedString("Message", comment: ""),
                                                        body: students)
            },
                                       errorHandler: { error in
                self?.handleError(with: error)
            })
        }
        
        let addToActiveAction = UIAlertAction(title: NSLocalizedString("AddToActiveTitle", comment: ""), style: .default) { [weak self] _ in
            guard let username = self?.rcsIDTextField.text, username != "" else {
                self?.handleError(with: .genericError(error: NSError(domain: "Empty String", code: 0, userInfo: [:])))
                return
            }
            ServicesAPI.addStudentsToActive(rcsID: username, successHandler: {
                SwiftMessagesWrapper.showGenericMessage(title:NSLocalizedString("Message", comment: "") ,
                                                        body: "Done")
            }, errorHandler: { error in
                self?.handleError(with: error)
            })
        }
        
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: NSLocalizedString("OptionsTitle", comment: ""),
                                                message: nil, preferredStyle: .actionSheet)
        alertController.addAction(adminLoginAction)
        alertController.addAction(showActiveStudentsAction)
        alertController.addAction(addToActiveAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = UIColor.red
        
        present(alertController, animated: true, completion: nil)
    }
    
}
