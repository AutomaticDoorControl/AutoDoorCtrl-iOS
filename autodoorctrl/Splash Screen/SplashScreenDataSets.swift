//
//  SplashScreenDataSets.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/12/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SplashScreenDataSets {
    lazy var dataSets: [PageContentDataSet] = {
        return [
            PageContentDataSet(
                title: "Welcome",
                content: "Thanks for becoming an Automatic Door Control user! We have a few tips to get you started.",
                showcaseImage: UIImage(named: "ADCOnboarding")),
            PageContentDataSet(
                title: "Opening a Door",
                content: "Select a discovered door from the list or tap on a location beacon on the map. Then, tap on the lock icon on the popup to open that door. ",
                showcaseImage: UIImage(named: "SplashScreenOpenDoor")),
            PageContentDataSet(
                title: "Reporting Issues",
                content: "In case you encounter any issues while using this product, there are few handy options in the settings page to help you contact the right people to solve these issues.",
                showcaseImage: UIImage(named: "SplashScreenReportIssue"))
        ]
    }()
}

class ExtraInfoDataSets {
    lazy var extraInfoDataSet: PageContentDataSet = {
        return PageContentDataSet(
            title: "On a Side Note",
            content: "This app does not have the functionality to reset your password should you forget it. If this happens to you, contact Disability Services or an Automatic Door Control admin.\n\nBefore you can fully take advantage of the app, we'll need a few permissions from you:",
            showcaseImage: nil)
        }()
}

