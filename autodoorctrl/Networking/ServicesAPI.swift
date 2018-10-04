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
    private static let activeUserString = "http://localhost:8080/api/active_user"
    private static let addStudentsString = "http://localhost:8080/api/addtoActive"
    private static let registerStudentString = "http://localhost:8080/api/request-access"
    private static let removeStudentString = "http://localhost:8080/api/remove"
    
    enum StudentOperations {
        case addToActive
        case register
        case remove
    }
    
    static func showActiveUser(successHandler: @escaping (String) -> Void,
                               errorHandler: @escaping (NetworkingError) -> Void) {
        Alamofire.request(activeUserString).responseJSON { response in
            if !response.result.isSuccess {
                errorHandler(.genericError(error: response.error))
            } else {
                guard let data  = response.data,
                    let str = String(data: data, encoding: String.Encoding.utf8) else {
                        errorHandler(.genericError(error: NSError(domain: "Unexpected Error", code: 0, userInfo: [:])))
                        return
                }
                successHandler(str)
            }
        }
    }
    
    
    /**
     Perform 3 types of operations on an RCSID: addToActive, register or remove
     */
    static func performOperationOnStudent(with rcsID: String, method: StudentOperations,
                              successHandler: @escaping () -> Void,
                              errorHandler: @escaping (NetworkingError) -> Void) {
        let params = ["RCSid": rcsID]
        let headers = ["Content-Type": "application/json"]
        
        var operationType: String
        switch method {
        case .addToActive:
            operationType = addStudentsString
        case .register:
            operationType = registerStudentString
        case .remove:
            operationType = removeStudentString
        }
        
        Alamofire.request(operationType, method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers: headers).responseJSON { json in
                            if let error = json.error {
                                // as it stands now, this actually signals the success of operations
                                if error.localizedDescription == "Response could not be serialized, input data was nil or zero length." {
                                    successHandler()
                                } else {
                                    errorHandler(.genericError(error: error))
                                }
                            } else {
                                // server sends no response back. If there's no obvious error then we have to assume
                                // that the process has succeeded
                                successHandler()
                            }
        }
    }
    
}
