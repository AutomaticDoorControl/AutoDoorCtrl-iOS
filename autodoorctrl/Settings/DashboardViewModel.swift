//
//  DashboardViewModel.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class DashboardViewModel: NSObject {
    
    let userInfoIdentifer = "userInfoCell"
    let actionIdentifier = "dashboardActionCell"
    
    let sectionTitles = [NSLocalizedString("myInfoTitle", comment: ""),
                         NSLocalizedString("supportTitle", comment: ""),
                         NSLocalizedString("Actions", comment: "")]
    let firstSectionCount = 2
    let secondSectionCount = 4
    
    let actionTitles = [NSLocalizedString("ShowActiveTitle", comment: ""),
                        NSLocalizedString("registerTitle", comment: ""),
                        NSLocalizedString("AddToActiveTitle", comment: ""),
                        NSLocalizedString("removeTitle", comment: "")]
    
    let supportTitles = [NSLocalizedString("contactFixxTitle", comment: "")]
    
    lazy var sectionCounts: [Int] = {
        return [2, supportTitles.count, actionTitles.count]
    }()
    
    override init () {
        super.init()
    }
    
    
    func loadCells(from indexPath: IndexPath) -> (String, String?, UIImage?) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return ("RCSID", User.current.rcsID, nil)
            } else if indexPath.row == 1 {
                return ("Status", User.current.isActive ? "Active" : "Inactive", nil)
            }
        } else if indexPath.section == 1 {
            return (supportTitles[indexPath.row], nil, UIImage(named: "wrenchIcon"))
        } else if indexPath.section == 2 {
            return (actionTitles[indexPath.row], nil, UIImage(named: "SettingsIcon"))
        }
        return ("", nil, nil)
    }
    
    // MARK: - Private
    
    func studentOperationsAlert(for mode: ServicesAPI.StudentOperations) -> UIViewController {
        let alert = UIAlertController(title: NSLocalizedString("enterRCSIDTitle", comment: ""),
                                      message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "RCSID" }
        
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Continue", comment: ""),
            style: .destructive, handler:
        { _ in
            guard let rcsID = alert.textFields?.first?.text else { return }
            ServicesAPI.performOperationOnStudent(with: rcsID, method: mode, successHandler: {
                SwiftMessagesWrapper.showSuccessMessage(title: NSLocalizedString("Message", comment: ""),
                                                        body: NSLocalizedString("Done", comment: ""))
            }, errorHandler: { $0.handleError() })
        }))
        
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .cancel,
            handler: nil))
        return alert
    }
    
}
