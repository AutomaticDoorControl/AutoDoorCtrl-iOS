//
//  ExtraInformationViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/12/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class ExtraInformationViewController: PageContentViewController {
    let dataSets = ExtraInfoDataSets()
    var didDismiss: (() -> Void) = {}
    
    // MARK: - Init
    init() {
        super.init(dataSet: dataSets.extraInfoDataSet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override var buttonText: String? {
        return "OK"
    }
    
    override func buttonTapped(sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.didDismiss()
        }
    }
    
    override var buttonBackgroundColor: UIColor {
        return Constants.adcRed
    }
    
    override var buttonTextColor: UIColor {
        return .white
    }
}

