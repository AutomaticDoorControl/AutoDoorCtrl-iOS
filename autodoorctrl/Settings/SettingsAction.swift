//
//  SettingsAction.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

enum SettingsAction {
    case contactFixx
    case submitComplaint
    case showActiveStudents
    case register
    case activate
    case remove
    case viewComplaints
    
    init?(indexPath: IndexPath) {
        let row = indexPath.row
        if indexPath.section == 1 {
            switch row {
            case 0:
                self = .contactFixx
            case 1:
                self = .submitComplaint
            default:
                return nil
            }
        } else if indexPath.section == 2 {
            switch row {
            case 0:
                self = .showActiveStudents
            case 1:
                self = .register
            case 2:
                self = .activate
            case 3:
                self = .remove
            case 4:
                self = .viewComplaints
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
