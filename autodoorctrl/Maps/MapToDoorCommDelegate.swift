//
//  MapToDoorCommDelegate.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/22/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

protocol MapToDoorCommDelegate: class {
    func didReceiveDoorsData(with doors: [Door])
    func didSelectSingleDoor(with door: Door)
    
    func expandList()
    func collapseList()
    func animateBottomSheet(amount: CGFloat, scrollToEdge: Bool)
}
