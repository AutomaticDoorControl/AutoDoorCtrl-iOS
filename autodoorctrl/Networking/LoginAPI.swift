//
//  LoginAPI.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/7/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import Alamofire

enum LoginAPI {
    
    static func loginUser(username: String, password: String,
                          successHandler: @escaping () -> Void,
                          errorHandler: @escaping (LoginError) -> Void) {
        if username == "abc" && password == "abc" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                successHandler()
            }
        } else {
            DispatchQueue.main.async {
                errorHandler(.invalidCredentials)
            }
        }
    }
}
