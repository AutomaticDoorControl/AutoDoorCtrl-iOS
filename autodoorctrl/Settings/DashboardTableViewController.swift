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
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.view.backgroundColor = Constants.adcRed
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionCounts[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let identifier = indexPath.section == 0 ? viewModel.userInfoIdentifer : viewModel.actionIdentifier
        
        cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let title: String, subtitle: String?, image: UIImage?
        (title, subtitle, image) = viewModel.loadCells(from: indexPath)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        cell.imageView?.image = image
        return cell
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
        if indexPath.section == 1 {
            composeMail()
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "showDashboardDetails", sender: self)
            } else if indexPath.row == 1 {
                present(viewModel.studentOperationsAlert(for: .register), animated: true, completion: nil)
            } else if indexPath.row == 2 {
                present(viewModel.studentOperationsAlert(for: .addToActive), animated: true, completion: nil)
            } else if indexPath.row == 3 {
                present(viewModel.studentOperationsAlert(for: .remove), animated: true, completion: nil)
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
            case .cancelled:
                SwiftMessagesWrapper.showWarningMessage(title: NSLocalizedString("mailComposingCancelled", comment: ""), body: "")
            case .saved:
                SwiftMessagesWrapper.showSuccessMessage(title: NSLocalizedString("mailSavedTitle" , comment: ""), body: "")
            case .sent:
                SwiftMessagesWrapper.showSuccessMessage(title: NSLocalizedString("mailSuccessfulTitle", comment: ""), body: "")
            case .failed:
                SwiftMessagesWrapper.showErrorMessage(title: NSLocalizedString("mailFailedTitle", comment: ""), body: "")
            @unknown default: break
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
        mailVC.setToRecipients(["fixx@rpi.edu"])
        mailVC.setSubject(NSLocalizedString("contactFixxSubject", comment: ""))
        present(mailVC, animated: true, completion: nil)
    }
}
