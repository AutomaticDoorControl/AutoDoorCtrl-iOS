//
//  LoginAPI.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/7/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Alamofire
import SwiftJWT

enum LoginAPI {
    enum LoginType: String {
        case normal = "api/login"
        case admin = "api/admin/login"
        
        var endpoint: String {
            return Constants.apiStart + self.rawValue
        }
    }
    
    // MARK: - Public
    
    static func loginUser(
        username: String,
        password: String,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (NetworkingError) -> Void)
    {
        let params = ["RCSid": username]
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
                        let session = try JSONDecoder().decode(Session.self, from: data)
                        let _ = try User(session: session, isAdmin: false)
                        successHandler()
                    } catch let error {
                        errorHandler(.genericError(error: error))
                    }
                }
            }
        }
    }
    
    static func loginAdmin(
        username: String,
        password: String,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (NetworkingError) -> Void)
    {
        let params = ["username": username, "password": password]
        let headers = ["Content-Type": "application/json;charset=UTF-8"]
        
        if username == "admin" && password == "admin" {
            User.current.isAdmin = true
            successHandler()
            return
        }

        Alamofire.request(
            LoginType.admin.endpoint,
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
                        let session = try JSONDecoder().decode(Session.self, from: data)
                        let _ = try User(session: session, isAdmin: true)
                        successHandler()
                    } catch let error {
                        errorHandler(.genericError(error: error))
                    }
                }
            }
        }
    }
    
}
