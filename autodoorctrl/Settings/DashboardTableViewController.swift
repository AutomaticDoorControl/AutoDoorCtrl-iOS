//
//  DashboardTableViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MessageUI

class DashboardTableViewController: UITableViewController {
    private let viewModel = DashboardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = Constants.adcRed
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.numberOfSections?(in: tableView) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.dataSource.tableView?(tableView, titleForHeaderInSection: section) ?? ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        handleActions(with: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: - IBActions

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Action Handlers
    
    func handleActions(with indexPath: IndexPath) {
        if let action = SettingsAction(indexPath: indexPath) {
            switch action {
            case .contactFixx:
                composeMail()
            case .submitComplaint:
                navigationController?.pushViewController(SubmitComplaintsViewController(), animated: true)
            case .showActiveStudents:
                performSegue(withIdentifier: "showDashboardDetails", sender: self)
            case .register:
                present(viewModel.studentOperationsAlert(for: .register), animated: true, completion: nil)
            case .activate:
                present(viewModel.studentOperationsAlert(for: .addToActive), animated: true, completion: nil)
            case .remove:
                present(viewModel.studentOperationsAlert(for: .remove), animated: true, completion: nil)
            case .viewComplaints:
                navigationController?.pushViewController(ViewComplaintsTableViewController(), animated: true)
            }
        }
    }
}

extension DashboardTableViewController: MFMailComposeViewControllerDelegate {
    // MARK: Mail Compose
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?)
    {
        controller.dismiss(animated: true) {
            if let error = error {
                SwiftMessagesWrapper.showErrorMessage(title: error.localizedDescription, body: "")
                return
            }
            switch result {
            case .saved:
                SwiftMessagesWrapper.showSuccessMessage(title: NSLocalizedString("mailSavedTitle" , comment: ""), body: "")
            case .sent:
                SwiftMessagesWrapper.showSuccessMessage(title: NSLocalizedString("mailSuccessfulTitle", comment: ""), body: "")
            case .failed:
                SwiftMessagesWrapper.showErrorMessage(title: NSLocalizedString("mailFailedTitle", comment: ""), body: "")
            default: break
            }
        }
    }
    
    func composeMail() {
        guard MFMailComposeViewController.canSendMail() else {
            SwiftMessagesWrapper.showErrorMessage(title: NSLocalizedString("ErrorTitle", comment: ""),
                                                  body: NSLocalizedString("mailNotSupportedTitle", comment: ""))
            return
        }
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(Constants.supportEmails)
        mailVC.setSubject(NSLocalizedString("contactFixxSubject", comment: ""))
        present(mailVC, animated: true, completion: nil)
    }
}
