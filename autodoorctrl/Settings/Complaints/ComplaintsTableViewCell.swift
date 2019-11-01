//
//  ComplaintsTableViewCell.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/26/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class ComplaintsTableViewCell: UITableViewCell {
    static let identifier = "complaintsLabel"
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func configure(with complaint: ServicesAPI.ComplaintResponse) {
        locationLabel.text = complaint.location
        messageLabel.text = complaint.message
    }
    
}
