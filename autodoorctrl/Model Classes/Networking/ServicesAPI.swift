//
//  ServicesAPI.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/29/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import Alamofire

enum ServicesAPI {
    
    // MARK: - Enums
    enum StudentOperations: String {
        case addToActive = "api/addtoActive"
        case register = "api/request-access"
        case remove = "api/remove"
        
        /// Return the server string needed to fetch json.
        var serverString: String {
            return Constants.apiStart + rawValue
        }
    }
    
    enum StatusOperations: String {
        case showActive = "api/active_user"
        
        var serverString: String {
           return Constants.apiStart + rawValue
        }
    }
    
    enum MiscOperations: String {
        case submitComplaint = "api/submit-complaint"
        
        var serverString: String {
           return Constants.apiStart + rawValue
        }
    }
    
    // MARK: - Structs
    struct UserResponse: Codable {
        let status: String
        let rcsID: String
        
        private enum CodingKeys: String, CodingKey {
            case status = "Status"
            case rcsID = "RCSid"
        }
    }
    
    // MARK: - Methods
    
    static func showUserInfo(
        method: StatusOperations,
        successHandler: @escaping ([User]) -> Void,
        errorHandler: @escaping (NetworkingError) -> Void)
    {
        
        let header = ["Content-Type": "application/json", "Authorization": "Bearer \(User.current.session.sessionID)"]
        Alamofire.request(
            method.serverString,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: header).responseJSON
        { json in
            if let error = json.error {
                errorHandler(.genericError(error: error))
            } else {
                do {
                    if let data = json.data {
                        let users = try JSONDecoder().decode([UserResponse].self, from: data)
                        successHandler(users.map { User(userResponse: $0) })
                    } else {
                        throw NSError(domain: "Invalid Data", code: 0, userInfo: nil)
                    }
                } catch let error {
                    errorHandler(.genericError(error: error))
                }
            }
        }
    }
    
    /**
     Perform 3 types of operations on an RCSID: addToActive, register or remove
     */
    static func performOperationOnStudent(
        with rcsID: String,
        method: StudentOperations,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (NetworkingError) -> Void)
    {
        let params = ["RCSid": rcsID]
        let header = ["Content-Type": "application/json", "Authorization": "Bearer \(User.current.session.sessionID)"]
        
        Alamofire.request(
            method.serverString,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: header).responseJSON
        { json in
            if let error = json.error {
                errorHandler(.genericError(error: error))
            } else {
                successHandler()
            }
        }
    }
    
    static func submitComplaints(
        location: String,
        complaint: String,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (NetworkingError) -> Void)
    {
        let params = ["Location": location, "Message": complaint]
        let headers = ["Content-Type": "application/json"]
        
        Alamofire.request(
            MiscOperations.submitComplaint.serverString,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseJSON
        { json in
            if let error = json.error {
                errorHandler(.genericError(error: error))
            } else {
                if let data = json.data, let message = String(data: data, encoding: .utf8) {
                    print(message)
                }
                successHandler()
            }
        }
    }
}
