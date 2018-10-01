//
//  DashboardTableViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController {
    private let controller = DashboardController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return controller.sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return controller.sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? controller.firstSectionCount : controller.secondSectionCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: controller.userInfoIdentifer, for: indexPath)
        } else  {
            cell = tableView.dequeueReusableCell(withIdentifier: controller.actionIdentifier, for: indexPath)
            cell.imageView?.image = UIImage(named: "SettingsIcon")
        }
        let title: String, subtitle: String?
        (title, subtitle) = controller.loadCells(from: indexPath)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        controller.handleActions(on: self, from: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: - IBActions

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

}
