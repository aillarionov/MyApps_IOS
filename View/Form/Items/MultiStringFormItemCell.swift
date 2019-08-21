//
//  StringFormItemCell.swift
//  Inform
//
//  Created by Александр on 24.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class MultiStringFormItemCell: UITableViewCell, FormItemViewProtocol, UITextViewDelegate {
    
    static let nib = UINib(nibName: "MultiStringFormItemCell", bundle: nil)
    static let cellIdentifier = "MultiStringFormItemCell"
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var data: FormItemData? {
        didSet {
            self.prepereCell()
        }
    }
    
    var listController: UIViewController? {
        didSet {
            self.textView.inputAccessoryView = listController?.getKeyboardToolbar()
        }
    }

    private func prepereCell() {
        if let data = self.data {
            self.label.text = data.formItem.title
            self.textView.text = data.value
        }
    }
    
    public func checkRequired() {
        if let data = self.data {
            if data.formItem.required && (data.value == nil || data.value == "") {
                self.textView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
            } else {
                self.textView.backgroundColor = nil
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.data?.value = textView.text
    }
    
    override func awakeFromNib() {
        selectionStyle = .none
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
