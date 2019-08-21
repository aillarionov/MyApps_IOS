//
//  PickerView.swift
//  Inform
//
//  Created by Александр on 25.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation
import UIKit

class PickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
  
    var pickerData : [String]!
    var pickerTextField : UITextField!
    var selectionHandler : ((_ selectedText: String) -> Void)?
    
    init(pickerData: [String], dropdownField: UITextField) {
        super.init(frame: CGRect.zero)
        
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
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
        self.pickerTextField.inputAccessoryView = toolBar
        
        
        
        DispatchQueue.main.async{
            if pickerData.count > 0 {
                if (self.pickerTextField.text == nil || !self.pickerData.contains(self.pickerTextField.text!)) {
                    self.pickerTextField.text = self.pickerData[0]
                }
                
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        }
    }
    
    convenience init(pickerData: [String], dropdownField: UITextField, onSelect selectionHandler : @escaping (_ selectedText: String) -> Void) {
        self.init(pickerData: pickerData, dropdownField: dropdownField)
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
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]

        if self.pickerTextField.text != nil && self.selectionHandler != nil {
            self.selectionHandler!(self.pickerTextField.text!)
        }
    }
    
    @objc func doneClick() {
        self.pickerTextField.resignFirstResponder()
    }
}
