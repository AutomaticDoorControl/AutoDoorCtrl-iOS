//
//  ViewComplaintsTableViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/26/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import JLActivityIndicator

class ViewComplaintsTableViewController: UITableViewController {
    var complaints: [ServicesAPI.ComplaintResponse] = []
    var activityIndicator: JLActivityIndicator? = nil
    
    init() {
        super.init(nibName: "ViewComplaintsTableViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("complaintsTitle", comment: "")
        
        tableView.register(UINib(nibName: "ComplaintsTableViewCell", bundle: .main), forCellReuseIdentifier: ComplaintsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 63
        tableView.tableFooterView = UIView() // elimate extra separators in the bottom
        
        activityIndicator = JLActivityIndicator(on: view, mode: .path)
        activityIndicator?.enableBackDrop = true
        activityIndicator?.start()
        
        ServicesAPI.getComplaints(successHandler: { [weak self] complaints in
            self?.complaints = complaints
            self?.tableView.reloadData()
            self?.activityIndicator?.stop()
        }, errorHandler: { [weak self] error in
            error.handleError()
            self?.activityIndicator?.stop()
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complaints.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ComplaintsTableViewCell.identifier, for: indexPath)
        
        if let cell = cell as? ComplaintsTableViewCell {
            cell.configure(with: complaints[indexPath.row])
        }
        return cell
    }
    
}
