//
//  SubmitComplaintsViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SubmitComplaintsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editLocationButton: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    let viewModel: SubmitComplaintsViewModel
    let pickerView = GenericPickerViewController<SubmitComplaintsViewController>(
        pickerViewData: DoorsAPI.prefetchedDoors.map { "\($0.value.location)" },
        title: NSLocalizedString("selectDoorLocationTitle", comment: ""),
        startIndex: 0,
        doneButtonTitle: NSLocalizedString("doneTitle", comment: ""),
        cancelButtonTitle: NSLocalizedString("Cancel", comment: ""))
    
    init() {
        viewModel = SubmitComplaintsViewModel()
        super.init(nibName: "SubmitComplaintsViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        viewModel = SubmitComplaintsViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.screenTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("submitTitle", comment: ""), style: .plain, target: self, action: #selector(submitComplaint))
        
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 0, right: 12)
        textView.text = viewModel.textViewPlaceholder
        textView.delegate = self
        refreshLayout()
        
        pickerView.delegate = self
        present(pickerView, animated: true, completion: nil)
    }
    
    func refreshLayout() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 613)
    }

    // MARK: - Selectors
    @objc func submitComplaint() {
        guard editLocationButton.text != "None" else {
            SwiftMessagesWrapper.showErrorMessage(
                title: NSLocalizedString("ErrorTitle", comment: ""),
                body: NSLocalizedString("mustSelectDoorTitle", comment: ""))
            return
        }
    }
    
    // MARK: - IBActions

    @IBAction func locationButtonTapped(_ sender: UITapGestureRecognizer) {
        present(pickerView, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension SubmitComplaintsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == viewModel.textViewPlaceholder {
            textView.text = ""
        }
    }
}

extension SubmitComplaintsViewController: GenericPickerViewDelegate {
    typealias SelectedValueType = String
    
    func convertStringToCustomType(from string: String) -> String {
        return string
    }
    
    func didCompleteWithSelection(selection: String, at index: Int) {
        editLocationButton.text = selection
        viewModel.selectedLocation = selection
    }
    
    func didCancelSelection() { }
}
