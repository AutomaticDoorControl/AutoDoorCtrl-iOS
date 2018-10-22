//
//  DashboardDetailsTableViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/4/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import JLActivityIndicator

class DashboardDetailsTableViewController: UITableViewController {
    var mode: ServicesAPI.StatusOperations = .showActive
    private var details: [User] = []
    private var activityIndicator: JLActivityIndicator?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Active Students", comment: "")
        tableView.rowHeight = 50.0
        
        activityIndicator = JLActivityIndicator(on: view, mode: .path)
        activityIndicator?.start()
    
        ServicesAPI.showUserInfo(method: mode, successHandler: { [weak self] users in
            self?.details = users
            self?.activityIndicator?.stop()
            self?.tableView.reloadData()
        }, errorHandler: { $0.handleError() })
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardDetailCell", for: indexPath)
        cell.textLabel?.text = details[indexPath.row].rcsID
        cell.detailTextLabel?.text = details[indexPath.row].isActive ? "Active" : "Inactive"
        return cell
    }

}
