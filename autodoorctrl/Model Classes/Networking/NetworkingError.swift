//
//  NetworkingError.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/7/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

enum NetworkingError {
    case invalidCredentials
    case incompleteCredentials
    case networkFailure
    case genericError(error: Error?)
    
    func handleError() {
        switch self {
        case .invalidCredentials:
            SwiftMessagesWrapper.showErrorMessage(title: NSLocalizedString("ErrorTitle", comment: ""),
                                                  body: NSLocalizedString("ErrorWrongCredsTitle", comment: ""))
        case .incompleteCredentials:
            SwiftMessagesWrapper.showErrorMessage(title:  NSLocalizedString("ErrorTitle", comment: ""),
                                                  body: NSLocalizedString("ErrorIncompleteCredsTitle", comment: ""))
        case .networkFailure:
            SwiftMessagesWrapper.showErrorMessage(title:  NSLocalizedString("ErrorTitle", comment: ""),
                                                  body: NSLocalizedString("ErrorNoInternetTitle", comment: ""))
        case .genericError(let error):
            let body = (error as NSError?)?.localizedDescription ?? ""
            SwiftMessagesWrapper.showErrorMessage(title: NSLocalizedString("ErrorTitle", comment: ""), body: body)
        }
    }
}
