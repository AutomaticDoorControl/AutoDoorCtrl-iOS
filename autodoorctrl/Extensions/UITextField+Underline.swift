//
//  UITextField+Underline.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/8/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit


extension UITextField {
    
    /**
     * Remove the current border of the text field and add an underline to it.
     */
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}
