//
//  LoginError.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/7/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

enum LoginError {
    case invalidCredentials
    case incompleteCredentials
    case networkFailure
    case genericError(error: Error?)
}
