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
    private static let loginString = "http://localhost:8080/api/login"
    private static let adminLoginString = "http://localhost:8080/api/admin/login"
    
    // MARK: - Public
    
    static func loginUser(username: String, password: String,
                          successHandler: @escaping () -> Void,
                          errorHandler: @escaping (LoginError) -> Void) {
        let params = ["RCSid": username]
        let headers = ["Content-Type": "application/json"]
        
        if username == "abc" && password == "abc" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { successHandler() }
            return
        }
        
        Alamofire.request(loginString, method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers: headers).responseJSON { json in
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
    static func loginAdmin(username: String, password: String,
                          successHandler: @escaping () -> Void,
                          errorHandler: @escaping (LoginError) -> Void) {
        let params = ["username": username, "password": password]
        let headers = ["Content-Type": "application/json"]

        Alamofire.request(adminLoginString, method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers: headers).responseJSON { json in
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
     */
    private static func parseJSONResponse(from json: Data?, originalRCSID rcsID: String) -> LoginError? {
        if let data = json,
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = jsonData as? [Dictionary<String, Any>],
            let status = dict.first?["Status"] as? String { // this will return the status - active?
            print(dict)
            if status.hasPrefix("Active") {
                return nil
            } else {
                return LoginError.genericError(error:
                    NSError(domain: "Student is inactive", code: 0, userInfo: [:]))
            }
        }
        return LoginError.genericError(error: NSError(domain: "Student does not exist in DB", code: 0, userInfo: [:]))
    }
    
}
