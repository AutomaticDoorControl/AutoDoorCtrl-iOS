//
//  DashboardViewModel.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class DashboardViewModel: NSObject {
    
    var dataSource: UITableViewDataSource = User.current.isAdmin ? AdminSettingsDataSource() : StandardSettingsDataSource()
    
    override init () {
        super.init()
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
