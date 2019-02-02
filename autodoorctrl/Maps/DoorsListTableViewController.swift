//
//  DoorsListTableViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/22/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import CoreBluetooth

class DoorsListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BLEManagerDelegate {
    @IBOutlet weak var slideBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slideBarHandle: UIView!
    @IBOutlet weak var noBLEWarning: UILabel!
    private let controller = DoorsListController()
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    private let scrollVelocityCutoff: CGFloat = 500
    
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
        
        BLEManager.current.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshBLEs), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Scan for Doors",
                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),      NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        refreshControl.tintColor = UIColor.black
        tableView.refreshControl = refreshControl
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            BLEManager.current.scan()
        }
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        haptic.impactOccurred()
        delegate?.didSelectSingleDoor(with: controller.doors[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Table view data source

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
    @IBAction func animateBottomSheet(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        guard view.frame.height - translation.y >= 170,
            view.frame.height - translation.y <= UIScreen.main.bounds.height * 0.6 else { return }
        // down: +, up: -
        switch sender.state {
        case .ended:
            let midLine = 170 + (UIScreen.main.bounds.height * 0.6 - 170) / 2
            if sender.velocity(in: view).y > 0 { //down
                // directly collapse if fast enough
                if abs(sender.velocity(in: view).y) >= scrollVelocityCutoff {
                    delegate?.collapseList()
                    return
                }
                if view.frame.height < midLine { // scroll to bottom
                    delegate?.animateBottomSheet(amount: view.frame.height - 170, scrollToEdge: true)
                } else { // scroll back to top
                    delegate?.animateBottomSheet(amount: view.frame.height - UIScreen.main.bounds.height * 0.6,
                                                 scrollToEdge: true)
                }
            } else  { // up
                // directly expand if fast enough
                if abs(sender.velocity(in: view).y) >= scrollVelocityCutoff {
                    delegate?.expandList()
                    return
                }
                if view.frame.height > midLine { // scroll to top
                    delegate?.animateBottomSheet(amount: view.frame.height - UIScreen.main.bounds.height * 0.6,
                                                 scrollToEdge: true)
                } else { // scroll back to bottom
                    delegate?.animateBottomSheet(amount: view.frame.height - 170, scrollToEdge: true)
                }
            }
            return
        default: break
        }
        
        sender.setTranslation(CGPoint.zero, in: view)
        delegate?.animateBottomSheet(amount: translation.y, scrollToEdge: false)
    }
    
    // MARK: BLEManagerDelegate
    
    func didDiscoverDoors(doors: [Door]) {
        noBLEWarning.isHidden = true
        delegate?.didReceiveDoorsData(with: doors)
        controller.doors = doors
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func didReceiveError(error: BLEError?) {
        tableView.refreshControl?.endRefreshing()
        noBLEWarning.isHidden = false
        error?.showErrorMessage()
        if let error = error, case .scanningTimeout = error {
            controller.doors.removeAll()
            tableView.reloadData()
        }
    }
    
    @objc func refreshBLEs() {
        BLEManager.current.delegate = self
        noBLEWarning.isHidden = true
        BLEManager.current.scan()
    }
}
