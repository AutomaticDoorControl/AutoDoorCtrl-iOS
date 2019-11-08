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
    
    func addRoundedCorner(cornerRadius: CGFloat = 10.0) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func addShadows() {
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }
    
    func addBorders(width: CGFloat = 2.0) {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = width
    }
    
    /// Reduce the opacity to the designated value.
    func dim(
        toOpaciity opacity: CGFloat = 0.3,
        duration: TimeInterval,
        completion: @escaping (Bool) -> Void = { _ in })
    {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.alpha = opacity
            },
            completion: { completed in
                completion(completed)
            })
    }
    
    /// Increase the opacity to 100%.
    func brighten(duration: TimeInterval, completion: @escaping (Bool) -> Void = { _ in }) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.alpha = 1
            },
            completion: { completed in
                completion(completed)
            })
    }
}
