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
        let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
        appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
    }
    
    override var buttonBackgroundColor: UIColor {
        return Constants.adcRed
    }
    
    override var buttonTextColor: UIColor {
        return .white
    }
}

