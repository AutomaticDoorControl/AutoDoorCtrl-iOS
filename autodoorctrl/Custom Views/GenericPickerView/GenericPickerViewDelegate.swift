//
//  GenericPickerViewDelegate.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 7/14/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

protocol GenericPickerViewDelegate: class {
    associatedtype SelectedValueType
    
    func convertStringToCustomType(from string: String) -> SelectedValueType
    func didCompleteWithSelection(selection: SelectedValueType, at index: Int)
    func didCancelSelection()
}
