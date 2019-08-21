//
//  GroupAddViewController.swift
//  Inform
//
//  Created by Александр on 03.04.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class GroupAddViewController: UIViewController {
    
    @IBOutlet weak var inputCode: UITextField!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var subscribers: UILabel!
    
    var btnSend: UIBarButtonItem?
    
    var go: Cancelable?
    var cg: Cancelable?
    var imgc: Cancelable?
    
    var orgId: Int?
    var loading: Int = 0

    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        super.init(nibName: "GroupAddViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        self.inputCode.inputAccessoryView = self.getKeyboardToolbar()
        
        self.btnSend = UIBarButtonItem.init(title: NSLocalizedString("Add", comment: "Group add view add button"), style: .plain, target: self, action: #selector(addPressed))
        self.btnSend!.isEnabled = false
        self.navigationItem.rightBarButtonItem = self.btnSend
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func seachPressed(_ sender: Any) {
        if let code = inputCode.text {
            self.find(code)
        }
    }
    
    @IBAction func scanPressed(_ sender: Any) {
        let ui = QRScanViewController(
            success: { code in
                self.inputCode.text = code
                self.find(code)
            },
            navigation: self.navigation
        )
        self.navigation.pushViewController(ui, animated: true)
    }
    
    @IBAction func choosePressed(_ sender: Any) {
        let ui = OrgListViewController()
        self.navigation.pushViewController(ui, animated: true)
    }
    
    
    @objc func addPressed() {
        guard let orgId = self.orgId else { return }
        
        let currentLoading = self.showLoading()
        
        self.cg = LocalDataStore.loadOrg(
            orgId,
            success: {
                DispatchQueue.main.async {
                    self.hideLoading(currentLoading)
                    (UIApplication.shared.delegate as! AppDelegate).setOrgId(orgId)
                }
                
            },
            failure: { error in
                DispatchQueue.main.async {
                    self.hideLoading(currentLoading)
                }
                if !(error is ErrorCanceled) {
                    print(error)
                }
            }
        )
    }
    
    private func find(_ code: String) {
        self.go = RemoteService.getOrg(
            code: code,
            success: { response in
                DispatchQueue.main.async {
                    self.label.text = response.data.name
                    self.imgc = ImageLoader.getTmpImage(imageView: self.picture, url: response.data.logo, orgId: nil)
                    self.orgId = response.data.id
                    self.inputCode.backgroundColor = nil
                    self.btnSend!.isEnabled = true
                }
        },
            failure: {
                print($0)
                DispatchQueue.main.async {
                    self.btnSend!.isEnabled = false
                    self.label.text = nil
                    self.imgc = nil
                    self.picture.image = nil
                    self.orgId = nil
                    self.inputCode.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
                }
        }
        )
    }

    
    private func showLoading() -> Int {
        let alert = UIAlertController(title: nil, message: NSLocalizedString("Loading...", comment: "Display loading circle"), preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        self.loading += 1
        
        return self.loading
    }
    
    private func hideLoading(_ loading: Int) {
        if self.loading == loading {
            dismiss(animated: false, completion: nil)
        }
    }
}
