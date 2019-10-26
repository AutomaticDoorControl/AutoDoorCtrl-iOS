//
//  ADCClaim.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/19/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import SwiftJWT
import Foundation

struct ADCClaim: Claims {
    let iat: Date
    let sub: String
    let exp: Date
}
