//
//  AboutAppViewController.swift
//  Inform
//
//  Created by Александр on 22.04.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var textSubject: UITextView!
    
    var btnSend: UIBarButtonItem?

    let navigation: UINavigationController
    
    var gc: Cancelable?
    
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        super.init(nibName: "AboutAppViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.compatibleIOS10()

        self.textEmail.inputAccessoryView = self.getKeyboardToolbar()
        self.textPhone.inputAccessoryView = self.getKeyboardToolbar()
        self.textSubject.inputAccessoryView = self.getKeyboardToolbar()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.btnSend = UIBarButtonItem.init(title: NSLocalizedString("Send", comment: "AboutApp view send button"), style: .plain, target: self, action: #selector(sendPressed))
        self.navigationItem.rightBarButtonItem = self.btnSend
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }

    @objc private func sendPressed() {
        self.btnSend!.isEnabled = false
        
        if self.textEmail.text == nil || self.textEmail.text == "" {
            self.textEmail.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
            self.btnSend!.isEnabled = true
            return
        } else {
            self.textEmail.backgroundColor = nil
        }

        let data = CallbackProxy(email: self.textEmail.text!, phone: self.textPhone.text, subject: self.textSubject.text)
        
        self.gc = RemoteService.sendCallback(
            data,
            success: { response in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("Success", comment: "Success alert title"), message: NSLocalizedString("Callback successfull sent", comment: "Success alert text"), preferredStyle: UIAlertControllerStyle.actionSheet)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Success alert button"), style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.btnSend!.isEnabled = true
                }
            },
            failure: { error in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("Alert", comment: "Failure alert title"), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Failure alert button"), style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.btnSend!.isEnabled = true
                }
            }
        );
    }
    
    
    
}
