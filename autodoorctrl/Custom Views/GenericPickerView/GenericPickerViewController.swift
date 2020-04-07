//
//  GenericPickerViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 9/7/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class GenericPickerViewController<T: GenericPickerViewDelegate>: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    let data: [String]
    let pickerViewTitle: String
    private var selectedValue: T.SelectedValueType?
    private var selectedIndex: Int?
    private var startIndex: Int?
    
    private var doneButtonTitle: String?
    private var cancelButtonTitle: String?
    
    weak var delegate: T?
    
    init(
        pickerViewData: [String],
        title: String,
        startIndex: Int?,
        doneButtonTitle: String = "Done",
        cancelButtonTitle: String = "Cancel")
    {
        guard !pickerViewData.isEmpty else { fatalError("Data must have at least one element") }
        data = pickerViewData
        pickerViewTitle = title
        self.startIndex = startIndex
        self.doneButtonTitle = doneButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
        super.init(nibName: "GenericPickerViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        visualEffectView.clipsToBounds = true
        visualEffectView.layer.cornerRadius = 10
        titleLabel.text = pickerViewTitle
        doneButton.setTitle(doneButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        
        if let startIndex = startIndex {
            pickerView.selectRow(startIndex, inComponent: 0, animated: true)
            selectedIndex = startIndex
            if let firstSelected = delegate?.convertStringToCustomType(from: data[startIndex]) {
                selectedValue = firstSelected
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IBAction

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate?.didCancelSelection()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if let selectedValue = selectedValue, let index = selectedIndex {
            delegate?.didCompleteWithSelection(selection: selectedValue, at: index)
        } else {
            delegate?.didCancelSelection()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func disableAreaTapped(_ sender: UITapGestureRecognizer) {
        if !visualEffectView.frame.contains(sender.location(in: self.view)) {
            dismiss(animated: true, completion: nil)
            delegate?.didCancelSelection()
        }
    }
    // MARK: - Picker View DataSource and Delegates
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = delegate?.convertStringToCustomType(from: data[row])
        selectedIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let labelColor: UIColor
        if #available(iOS 13.0, *) {
            labelColor = UIColor.label
        } else {
            labelColor = UIColor.black
        }
        return NSAttributedString(string: data[row], attributes: [
            .foregroundColor: labelColor,
            .font: UIFont.systemFont(ofSize: 16.0)
        ])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
}
