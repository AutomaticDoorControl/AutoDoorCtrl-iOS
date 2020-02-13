//
//  String+Error.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 2/5/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Foundation

extension String: Error {
    
}

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}
