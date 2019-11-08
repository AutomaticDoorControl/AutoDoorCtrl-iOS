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
    
    var description: String {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("ErrorWrongCredsTitle", comment: "")
        case .incompleteCredentials:
            return NSLocalizedString("ErrorIncompleteCredsTitle", comment: "")
        case .networkFailure:
            return NSLocalizedString("ErrorNoInternetTitle", comment: "")
        case .genericError(let error):
            return (error as NSError?)?.localizedDescription ?? ""
        }
    }
    
    func handleError() {
        SwiftMessagesWrapper.showErrorMessage(title: NSLocalizedString("ErrorTitle", comment: ""), body: description)
    }
}
