//
//  UIView+Customizations.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/21/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addRoundBorder(borderRadius: CGFloat = 10.0) {
        self.layer.cornerRadius = borderRadius
        self.clipsToBounds = true
    }
    
    func addShadows() {
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }
    
    func addBorders(width: CGFloat = 2.0) {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = width
    }
}
