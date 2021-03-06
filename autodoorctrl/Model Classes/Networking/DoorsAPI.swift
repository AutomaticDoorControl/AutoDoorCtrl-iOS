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
import RxSwift

enum DoorsAPI {
    private enum RequestTypes: String {
        case getDoors = "api/get_doors"
        case openDoor = "api/open_door"
        
        var endpoint: String {
            return Constants.apiStart + rawValue
        }
    }
    
    static var prefetchedDoors: [String: DoorResponse] = [:]
    
    static func prefetchDoorsData(
        success: @escaping () -> Void,
        error: @escaping (Error) -> Void)
    {
        Alamofire.request(
            RequestTypes.getDoors.endpoint,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil).responseJSON
        { json in
            if let data = json.data {
                do {
                    let doorData = try JSONDecoder().decode([DoorResponse].self, from: data)
                    prefetchedDoors = Dictionary(uniqueKeysWithValues: doorData.map { ($0.name, $0) })
                    DispatchQueue.main.async {
                        success()
                    }
                } catch let err {
                    error(err)
                }
            } else {
                error("Invalid JSON")
            }
        }
    }
    
    static func openDoor(
        _ door: Door,
        success: @escaping (_ totp: TOTP) -> Void,
        error: @escaping (NetworkingError) -> Void)
    {
        let params = ["door": door.name]
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(User.current.session.sessionID)"]
        
        Alamofire.request(
            RequestTypes.openDoor.endpoint,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseJSON
        { json in
            if let err = json.error {
                error(.genericError(error: err))
            } else {
                do {
                    if let data = json.data {
                        do {
                            let totp = try JSONDecoder().decode(TOTP.self, from: data)
                            success(totp)
                        } catch let err {
                            error(.genericError(error: err))
                        }
                    } else {
                        throw "Invalid Data"
                    }
                    
                } catch let err {
                    error(.genericError(error: err))
                }
            }
        }
    }
}

extension DoorsAPI {
    // MARK: - RX
    enum rx {
        static func openDoor(_ door: Door) -> Observable<TOTP> {
            Observable<TOTP>.create { observable in
                DoorsAPI.openDoor(door, success: { totp in
                    observable.onNext(totp)
                }, error: { e in
                    observable.onError(e.description)
                })
                return Disposables.create()
            }
        }
    }
}
