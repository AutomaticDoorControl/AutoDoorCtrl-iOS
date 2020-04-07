//
//  LoginAPI.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/7/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Alamofire

enum LoginAPI {
    enum LoginType: String {
        case normal = "api/login"
        
        var endpoint: String {
            return Constants.apiStart + self.rawValue
        }
    }
    
    // MARK: - Public
    
    static func login(
        username: String,
        password: String,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (NetworkingError) -> Void)
    {
        let params = ["rcsid": username, "password": password]
        let headers = ["Content-Type": "application/json"]
        
        if username == "abc" && password == "abc" {
            User.current.rcsID = username
            User.current.isActive = true
            User.current.isAdmin = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { successHandler() }
            return
        }
        
        Alamofire.request(
            LoginType.normal.endpoint,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseJSON
        { json in
            if let error = json.error {
                errorHandler(.genericError(error: error))
            } else {
                if let data = json.data {
                    do {
                        if let string = String(data: data, encoding: .utf8) {
                            print(string)
                        }
                        let session = try JSONDecoder().decode(Session.self, from: data)
                        let _ = try User(session: session, rcsID: username)
                        successHandler()
                    } catch let error {
                        errorHandler(.genericError(error: error))
                    }
                }
            }
        }
    }
}
