//
//  SettingsViewController.swift
//  Inform
//
//  Created by Александр on 01.04.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mode: UISegmentedControl!
    
    @IBOutlet weak var progressAnimation: UIActivityIndicatorView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var btnLoad: UIButton!
    @IBOutlet weak var btnClean: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    let navigation: UINavigationController
    var settings: Settings
    
    var cancelable: Cancelable?
    var si: Cancelable?
    
    init(settings: Settings, navigation: UINavigationController) {
        self.settings = settings
        self.navigation = navigation
        super.init(nibName: "SettingsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = aDecoder.value(forKey: "settings") as! Settings
        self.navigation = aDecoder.value(forKey: "navigation") as! UINavigationController
        super.init(coder: aDecoder)
    }  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        mode.selectedSegmentIndex = (settings.isPresenter ? 1 : 0)
        
        if let org = self.settings.org {
            self.cancelable = ImageLoader.getTmpImage(imageView: self.image, url: org.logo, orgId: settings.id)
        } else {
            self.cancelable = nil
        }
    }
    
    @IBAction func modeChanged(_ sender: Any) {
        do {
            let worker = DataWorker()
            let dao = SettingsDAO(context: worker.begin())

            self.settings.isVisitor = (self.mode.selectedSegmentIndex == 0 ? true : false)
            self.settings.isPresenter = (self.mode.selectedSegmentIndex == 1 ? true : false)
            dao.update(self.settings)
            
            try worker.commmit()
            
            (UIApplication.shared.delegate as! AppDelegate).sendClientData()
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func loadPressed(_ sender: Any) {
        self.progressAnimation.startAnimating()
        
        self.si = LocalDataStore.storeOrgImages(
            self.settings.id,
            success: {
                DispatchQueue.main.async {
                    self.progressAnimation.stopAnimating()
                }
            },
            failure: { error in
                DispatchQueue.main.async {
                    self.progressAnimation.stopAnimating()
                }
            },
            progress: { i, total  in
                let p: Float = (total > 0 ? Float(i) / Float(total) : 1)
                
                DispatchQueue.main.async {
                    self.progress.setProgress(p, animated: true)
                    if p == 1 {
                        self.progressAnimation.stopAnimating()
                    }
                }

            }
        )
    }
    
    @IBAction func cleanPressed(_ sender: Any) {
        do {
            try ImageStoreService.clearImages(forOrg: self.settings.id, storeType: ImageStoreType.Temporary)
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Confirmation", comment: "Delete confirmation dialog title"), message: NSLocalizedString("Exhibition will be removed", comment: "Delete confirmation dialog text"), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Remove", comment: "Delete confirmation dialog button"), style: .default, handler: self.deleteGroup))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Delete confirmation dialog button"), style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func deleteGroup(_ uialert: UIAlertAction) {
        do {
            if let org = self.settings.org {
                try LocalDataStore.deleteOrg(org)
                
                let app = (UIApplication.shared.delegate as! AppDelegate)
                if org.id == app.getOrgId() {
                    app.setOrgId(0)
                }
                
                self.navigation.popViewController(animated: true)
            }
        } catch let error {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
