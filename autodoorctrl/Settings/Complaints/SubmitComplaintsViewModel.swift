//
//  SubmitComplaintsViewModel.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SubmitComplaintsViewModel {
    let screenTitle = NSLocalizedString("submitComplaintScreenTitle", comment: "")
    let textViewPlaceholder = NSLocalizedString("complaintsPlaceholderTitle", comment: "")
    var selectedLocation = NSLocalizedString("noneTitle", comment: "")
    var complaint: String = ""
    
    func submitComplaint(success: @escaping () -> Void, error: @escaping (NetworkingError) -> Void) {
        ServicesAPI.submitComplaints(
            location: selectedLocation,
            complaint: complaint,
            successHandler: {
                success()
            },
            errorHandler: { err in
                error(err)
            })
    }
 }
