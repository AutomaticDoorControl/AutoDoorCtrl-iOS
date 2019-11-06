//
//  Error+Extensions.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/5/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

extension Error {
    func showErrorMessage() {
        SwiftMessagesWrapper.showErrorMessage(
            title: NSLocalizedString("ErrorTitle", comment: ""),
            body: localizedDescription)
    }
}
