//
//  UIButton+DynamicType.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/21/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    @IBInspectable
    var dynamicType: Bool {
        set {
            self.titleLabel?.adjustsFontForContentSizeCategory = newValue
        } get {
            return self.titleLabel?.adjustsFontForContentSizeCategory ?? false
        }
    }
}
