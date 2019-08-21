//
//  UIViewController+Extensions.swift
//  Inform
//
//  Created by Александр on 30.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public static let doneButtonTile = NSLocalizedString("Done", comment: "Done button over keyboard")
    
    func compatibleIOS10 () {
        if #available(iOS 11.0, *) {
        } else {
            self.edgesForExtendedLayout = []
        }
    }
    
    func getKeyboardToolbar() -> UIToolbar {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: UIViewController.doneButtonTile, style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        return toolbar;
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
}
