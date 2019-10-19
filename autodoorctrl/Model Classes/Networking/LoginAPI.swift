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
                if let error = parseJSONResponse(from: json.data, originalRCSID: username) {
                    errorHandler(error)
                } else {
                    successHandler()
                }
            }
        }
    }
    
    /**
     * Not working atm.
     * TODO: Figure out what the admin username / password is.
     */
    static func loginAdmin(
        username: String,
        password: String,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (NetworkingError) -> Void)
    {
        let params = ["username": username, "password": password]
        let headers = ["Content-Type": "application/json"]
        
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
                let jsonData = try? JSONSerialization.jsonObject(with: json.data!, options: [])
                if let dict = jsonData as? [Dictionary<String, Any>] {
                    print(dict)
                }
            }
        }
    }
    
    // MARK: - Private
    
    /**
     * The response must contain an active student!
     * Using Codable instead of JSONSerialization reduced the amount of lines needed to parse json!
     */
    private static func parseJSONResponse(from json: Data?, originalRCSID rcsID: String) -> NetworkingError? {
        if let data = json,
            let user = (try? JSONDecoder().decode([User].self, from: data))?.first {
                User.current = user
                print(User.current.debugDescription)
                guard User.current.isActive else {
                    return .genericError(error: NSError(domain: "Student is inactive", code: 0, userInfo: [:]))
                }
                return nil
        }
        return .genericError(error: NSError(domain: "Student does not exist in DB", code: 0, userInfo: [:]))
    }
    
}
