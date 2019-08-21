//
//  PickerView.swift
//  Inform
//
//  Created by Александр on 25.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation
import UIKit

class SimplePickerView<T> : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
  
    var pickerData: [T]!
    var selectionHandler : ((_ selected: T) -> Void)?
    var textHandler: ((_ data: T) -> String?)?
    
    var invisibleTextField : UITextField!
    
    var selected: T?
    
    init(pickerData: [T], dropdownField: UITextField) {
        super.init(frame: CGRect.zero)
        
        self.pickerData = pickerData
        self.invisibleTextField = dropdownField
        self.delegate = self
        self.dataSource = self
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: UIViewController.doneButtonTile, style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.invisibleTextField.inputAccessoryView = toolBar
        self.selected = pickerData.first
    }
    
    convenience init(
        pickerData: [T],
        dropdownField: UITextField,
        textHandler : @escaping (_ data: T) -> String?,
        onSelect selectionHandler : @escaping (_ selected: T) -> Void
        ) {
        self.init(pickerData: pickerData, dropdownField: dropdownField)
        self.textHandler = textHandler
        self.selectionHandler = selectionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.textHandler != nil ? self.textHandler!(pickerData[row]) : nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected = pickerData[row]
    }
    
    @objc func doneClick() {
        if let selected = self.selected {
            self.selectionHandler!(selected)
        }
        self.invisibleTextField.resignFirstResponder()
    }
}
