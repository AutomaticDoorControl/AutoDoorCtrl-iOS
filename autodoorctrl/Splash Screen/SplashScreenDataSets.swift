//
//  SplashScreenDataSets.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/12/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class SplashScreenDataSets {
    lazy var dataSets: [PageContentDataSet] = {
        return []
    }()
}

class ExtraInfoDataSets {
    lazy var extraInfoDataSet: PageContentDataSet = {
        return PageContentDataSet(
            title: "More Info",
            content: "This app does not have the functionality to reset your password should you forget it. If this happens to you, contact disability services or an Automatic Door Control admin",
            showcaseImage: nil)
        }()
}

