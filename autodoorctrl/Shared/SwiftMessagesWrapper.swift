//
//  SwiftMessagesWrapper.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/7/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import SwiftMessages

enum SwiftMessagesWrapper {
    
    static func showErrorMessage(title: String, body: String) {
        SwiftMessagesWrapper.showMessage(title: title, body: body, style: .error)
    }
    
    static func showWarningMessage(title: String, body: String) {
        SwiftMessagesWrapper.showMessage(title: title, body: body, style: .warning)
    }
    
    // MARK: - Private Helper Methods
    
    private static func showMessage(title: String, body: String, style: Theme) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(style)
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.button?.isHidden = true
        SwiftMessages.show(view: view)
    }
}
