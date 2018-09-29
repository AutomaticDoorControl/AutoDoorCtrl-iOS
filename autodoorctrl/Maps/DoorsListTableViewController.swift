//
//  DoorsListTableViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/22/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class DoorsListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var slideBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slideBarHandle: UIView!
    private let controller = DoorsListController()
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    weak var delegate: MapToDoorCommDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideBarHandle.addRoundedCorner(cornerRadius: 3.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.register(UINib(nibName: "DoorsListTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: DoorsListTableViewCell.identifier)
        
        controller.fetchDoorsInfo(from: nil,
                                           successHandler: { [weak self] in
                                            self?.delegate?.didReceiveDoorsData(with: self?.controller.doors ?? [])
                                            self?.tableView.separatorColor = UIColor.black
                                            self?.tableView.reloadData()
        },
                                           errorHandler: { error in
                                            SwiftMessagesWrapper.showErrorMessage(title: "Error",
                                                                                  body: NSLocalizedString("ErrorNoDoorsTitle", comment: ""))
        })
        
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        haptic.impactOccurred()
        delegate?.didSelectSingleDoor(with: controller.doors[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.doors.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DoorsListTableViewCell.identifier, for: indexPath)

        if let doorsCell = cell as? DoorsListTableViewCell {
            doorsCell.setup(from: controller.doors[indexPath.row])
        }

        return cell
    }
    
    // MARK: IBActions
    
    @IBAction func expand(_ sender: UISwipeGestureRecognizer) { delegate?.expandList() }
    
     @IBAction func collapse(_ sender: UISwipeGestureRecognizer) { delegate?.collapseList() }
}
