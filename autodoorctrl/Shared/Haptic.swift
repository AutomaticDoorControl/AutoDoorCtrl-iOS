//
//  Haptic.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 2/12/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

class Haptic {
    static let current = Haptic()
    private let lightHaptic: UISelectionFeedbackGenerator
    private let hardHaptic: UIImpactFeedbackGenerator
    
    init() {
        lightHaptic = UISelectionFeedbackGenerator()
        hardHaptic = UIImpactFeedbackGenerator(style: .medium)
    }
    
    func generateLightHaptic() {
        lightHaptic.selectionChanged()
    }
    
    func generateHardHaptic() {
        hardHaptic.impactOccurred()
    }
}
