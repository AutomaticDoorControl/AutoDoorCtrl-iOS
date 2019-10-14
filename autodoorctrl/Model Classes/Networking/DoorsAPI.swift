//
//  DoorsAPI.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/22/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

enum DoorsAPI {
    private static let dataURL = "https://raw.githubusercontent.com/AutomaticDoorControl/AutomaticDoorControl/master/DoorsData.json"
    
    static var prefetchedDoors: [String: DoorResponse.DoorResponseData] = [:]
    
    static func prefetchDoorsData(
        success: @escaping () -> Void,
        error: @escaping (Error) -> Void)
    {
        Alamofire.request(
            dataURL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil).responseJSON
        { json in
            if let data = json.data {
                do {
                    let doorData = try JSONDecoder().decode(DoorResponse.self, from: data)
                    prefetchedDoors = Dictionary(uniqueKeysWithValues:
                        doorData.data.map { ($0.name, $0) })
                    DispatchQueue.main.async {
                        success()
                    }
                } catch let err {
                    error(err)
                }
            } else {
                error(NSError(domain: "Invalid JSON", code: 0, userInfo: nil))
            }
        }
    }
}
