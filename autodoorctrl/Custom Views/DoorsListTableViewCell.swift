//
//  DoorsListTableViewCell.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/22/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class DoorsListTableViewCell: UITableViewCell {
    @IBOutlet weak var doorsImageView: UIImageView!
    @IBOutlet weak var masterLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    static let identifier = "doorsListTableViewCell"
    
    func setup(from door: Door) {
        doorsImageView.image = UIImage(named: "UnlockIcon")
        masterLabel.text = door.name
        detailLabel.text = door.subtitle
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
}
