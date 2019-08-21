//
//  FormViewController.swift
//  Inform
//
//  Created by Александр on 01.04.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class FormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var btnSend: UIBarButtonItem?
    
    private let formId: Int
    private let navigation: UINavigationController
    private var items: [FormItemData] = []
    private var form: Form?
    
    private var rs: Cancelable?
    
    init(formId: Int, navigation: UINavigationController) {
        self.formId = formId
        self.navigation = navigation
        super.init(nibName: "FormViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.btnSend = UIBarButtonItem.init(title: NSLocalizedString("Send", comment: "Form view send button"), style: .plain, target: self, action: #selector(sendPressed))
        self.navigationItem.rightBarButtonItem = self.btnSend
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.register(StringFormItemCell.nib, forCellReuseIdentifier: StringFormItemCell.cellIdentifier)
        tableView.register(MultiStringFormItemCell.nib, forCellReuseIdentifier: MultiStringFormItemCell.cellIdentifier)
        
        
        let context = Globals.getViewContext()
        self.items = FormItemDAO(context: context).list(forForm: self.formId).map{ FormItemData(formItem: $0, value: nil) }
        
        if let form = FormDAO(context: context).get(self.formId) {
            self.form = form
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func sendPressed() {
        self.btnSend!.isEnabled = false
        // Проверка обязательности заполнения
        var required: Bool = false
        var selected: Bool = false
        
        for (i, item) in self.items.enumerated() {
            let indexPath = IndexPath(row: i, section: 0)
            
            if item.formItem.required && (item.value == nil || item.value!.isEmpty) {
                
                if !selected {
                    self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
                    selected = true
                }
                
                required = true
            }
            
            if let tc = self.tableView.cellForRow(at: indexPath) {
                let cell = tc as! UITableViewCell & FormItemViewProtocol
                cell.checkRequired()
            }
        }
        
        if required {
            self.btnSend!.isEnabled = true
            return
        }
        
        var formDataItems: [FormDataItemProxy] = []
        
        // Подготовка данных
        for item in self.items {
            if let value = item.value {
                formDataItems.append(FormDataItemProxy(name: item.formItem.name, value: value))
            }
        }
        
        let formData: FormDataProxy = FormDataProxy(formId: self.formId, data: formDataItems)
        
        self.rs = RemoteService.sendForm(
            formData,
            success: { response in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("Success", comment: "Success alert title"), message: NSLocalizedString("Form successfull sent", comment: "Success alert text"), preferredStyle: UIAlertControllerStyle.actionSheet)
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
        )
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    //    }
    
    // UITableViewDataSourco
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formItemData = self.items[indexPath.row]
        
        var cellIdentifier: String = StringFormItemCell.cellIdentifier
        
        switch formItemData.formItem.type {
        case .String: cellIdentifier = StringFormItemCell.cellIdentifier
        case .Phone: cellIdentifier = StringFormItemCell.cellIdentifier
        case .Email: cellIdentifier = StringFormItemCell.cellIdentifier
        case .Text: cellIdentifier = MultiStringFormItemCell.cellIdentifier
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UITableViewCell & FormItemViewProtocol
        
        cell.data = formItemData
        
        if cell.listController == nil {
            cell.listController = self
        }
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
