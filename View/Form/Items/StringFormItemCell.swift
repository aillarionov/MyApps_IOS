//
//  StringFormItemCell.swift
//  Inform
//
//  Created by Александр on 24.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class StringFormItemCell: UITableViewCell, FormItemViewProtocol {
    
    static let nib = UINib(nibName: "StringFormItemCell", bundle: nil)
    static let cellIdentifier = "StringFormItemCell"
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textEdit: UITextField!
    
    var data: FormItemData? {
        didSet {
            self.prepereCell()
        }
    }

    var listController: UIViewController? {
        didSet {
            self.textEdit.inputAccessoryView = listController?.getKeyboardToolbar()
        }
    }
    
    private func prepereCell() {
        if let data = self.data {
            self.label.text = data.formItem.title
            
            self.setKeyboardMode()
            
            if #available(iOS 10.0, *) {
                self.setContentMode()
            } else {
                // Fallback on earlier versions
            }
            
            self.textEdit.text = data.value
        }
    }
    
    @available(iOS 10.0, *)
    private func setContentMode() {
        if let data = self.data {
            switch data.formItem.type {
            case .Phone:
                self.textEdit.textContentType = UITextContentType.telephoneNumber
            case .Email:
                self.textEdit.textContentType = UITextContentType.emailAddress
            default:
                self.textEdit.textContentType = nil
                
            }
        }
    }
    
    private func setKeyboardMode() {
        if let data = self.data {
            switch data.formItem.type {
            case .Phone:
                self.textEdit.keyboardType = UIKeyboardType.phonePad
            case .Email:
                self.textEdit.keyboardType = UIKeyboardType.emailAddress
            default:
                self.textEdit.keyboardType = UIKeyboardType.default
                
            }
        }
    }
    
    public func checkRequired() {
        if let data = self.data {
            if data.formItem.required && (data.value == nil || data.value == "") {
                self.textEdit.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
            } else {
                self.textEdit.backgroundColor = nil
            }
        }
    }
    
    @IBAction func textChanged(_ sender: Any) {
        self.data?.value = self.textEdit.text
    }

    override func awakeFromNib() {
        selectionStyle = .none
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
