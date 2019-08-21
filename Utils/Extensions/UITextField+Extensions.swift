//
//  UITextField+Extensions.swift
//  Inform
//
//  Created by Александр on 25.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func loadDropdownData(_ data: [String]) {
        self.inputView = PickerView(pickerData: data, dropdownField: self)
    }
    
    func loadDropdownData(_ data: [String], onSelect selectionHandler : @escaping (_ selectedText: String) -> Void) {
        self.inputView = PickerView(pickerData: data, dropdownField: self, onSelect: selectionHandler)
    }
}
