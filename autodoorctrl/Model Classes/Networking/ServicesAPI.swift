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
        case addToActive = "api/add_to_active"
        case register = "api/request_access"
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
        case submitComplaint = "api/submit_complaint"
        case getComplaints = "api/get_complaints"
        
        var serverString: String {
           return Constants.apiStart + rawValue
        }
    }
    
    // MARK: - Structs
    struct UserResponse: Codable {
        let rcsID: String
        
        private enum CodingKeys: String, CodingKey {
            case rcsID = "rcsid"
        }
    }
    
    struct ComplaintResponse: Codable {
        let location: String
        let message: String
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
                        throw "Invalid Data"
                    }
                } catch let error {
                    errorHandler(.genericError(error: error))
                }
            }
        }
    }
    
    /// Perform 3 types of operations on an RCSID: addToActive, register or remove
    static func performOperationOnStudent(
        with rcsID: String,
        method: StudentOperations,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (NetworkingError) -> Void)
    {
        let params = ["rcsid": rcsID]
        let header = ["Content-Type": "application/json", "Authorization": "Bearer \(User.current.session.sessionID)"]
        
        Alamofire.request(
            method.serverString,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: header).responseString
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
        let params = ["location": location, "message": complaint]
        let headers = ["Content-Type": "application/json"]
        
        Alamofire.request(
            MiscOperations.submitComplaint.serverString,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseString
        { resp in
            if let error = resp.error {
                errorHandler(.genericError(error: error))
            } else {
                successHandler()
            }
        }
    }
    
    static func getComplaints(
        successHandler: @escaping ([ComplaintResponse]) -> Void,
        errorHandler: @escaping (NetworkingError) -> Void)
    {
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(User.current.session.sessionID)"]
        Alamofire.request(
            MiscOperations.getComplaints.serverString,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseJSON
        { json in
            if let error = json.error {
                errorHandler(.genericError(error: error))
            } else {
                do {
                    if let data = json.data {
                        let complaints = try JSONDecoder()
                                .decode([ComplaintResponse].self, from: data)
                                .filter { !$0.location.isEmpty && !$0.message.isEmpty }
                        successHandler(complaints)
                    } else {
                        throw "Invalid Data"
                    }
                    
                } catch let error {
                    errorHandler(.genericError(error: error))
                }
            }
        }
    }
}
