//
//  UITextField+Underline.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/8/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit


extension UITextField {
    
    /**
     * Remove the current border of the text field and add an underline to it.
     */
    func setBottomBorder() {
        borderStyle = .none
        
        if #available(iOS 13.0, *) {
            layer.backgroundColor = UIColor.systemBackground.cgColor
        } else {
            layer.backgroundColor = UIColor.white.cgColor
        }
        
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
    
}
