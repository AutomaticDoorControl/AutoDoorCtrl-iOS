//
//  SubmitComplaintsViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import JLActivityIndicator

class SubmitComplaintsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editLocationButton: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    private var submitButton: UIBarButtonItem?
    
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
        submitButton = UIBarButtonItem(title: NSLocalizedString("submitTitle", comment: ""), style: .plain, target: self, action: #selector(submitComplaint))
        navigationItem.rightBarButtonItem = submitButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        editLocationButton.text = NSLocalizedString("noneTitle", comment: "")
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
    
    func enableOrDisableEditLocation() {
        let none = NSLocalizedString("noneTitle", comment: "")
        submitButton?.isEnabled = textView.text != none && !textView.text.isEmpty && editLocationButton.text != none
    }

    // MARK: - Selectors
    @objc func submitComplaint() {
        let activityIndicator = JLActivityIndicator(on: view, mode: .path)
        activityIndicator.enableBackDrop = true
        activityIndicator.start()
        viewModel.submitComplaint(success: { [weak self] in
            SwiftMessagesWrapper.showSuccessMessage(
                title: NSLocalizedString("successTitle", comment: ""),
                body: NSLocalizedString("sendComplaintsSuccessfulTitle" , comment: ""))
            activityIndicator.stop()
            self?.navigationController?.popViewController(animated: true)
        }, error: { e in
            activityIndicator.stop()
            e.handleError()
        })
        
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
    
    func textViewDidChange(_ textView: UITextView) {
        enableOrDisableEditLocation()
        viewModel.complaint = textView.text
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
