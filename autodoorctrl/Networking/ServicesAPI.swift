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
    
    static func showActiveUser(successHandler: @escaping (String) -> Void,
                               errorHandler: @escaping (LoginError) -> Void) {
        Alamofire.request(activeUserString).responseJSON { response in
            if !response.result.isSuccess {
                errorHandler(.genericError(error: response.error))
            } else {
                guard let data  = response.data else { return }
                successHandler(String(data: data, encoding: String.Encoding.utf8) ?? "")
            }
        }
    }
    
    static func addStudentsToActive(rcsID: String,
                                    successHandler: @escaping () -> Void,
                                    errorHandler: @escaping (LoginError) -> Void) {
        let params = ["RCSid": rcsID]
        let headers = ["Content-Type": "application/json"]

        Alamofire.request(addStudentsString, method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers: headers).responseJSON { json in
                            if let error = json.error {
                                errorHandler(.genericError(error: error))
                            } else {
                                if let data = json.data,
                                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
                                    let dict = jsonData as? [Dictionary<String, Any>] {
                                    print(dict)
                                }
                            }
        }
    }
    
}
