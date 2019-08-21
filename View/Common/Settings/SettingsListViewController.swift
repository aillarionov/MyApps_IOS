//
//  SettingsListViewController.swift
//  Inform
//
//  Created by Александр on 01.04.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class SettingsListViewController: UIViewController {

    var btnSend: UIBarButtonItem?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelVersion: UILabel!
    
    let navigation: UINavigationController
    
    var dc: QueryTableDataController<SettingsCell>?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        super.init(nibName: "SettingsListViewController", bundle: nil)

        self.btnSend = UIBarButtonItem.init(title: NSLocalizedString("Catalog", comment: "Settings view add button"), style: .plain, target: self, action: #selector(addPressed))
        self.navigationItem.rightBarButtonItem = self.btnSend
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.compatibleIOS10()
        
        self.labelVersion.text = "v. " + Globals.shared.version
        
        let context = Globals.getViewContext()
        let dao = SettingsDAO(context: context)
        
        self.dc = QueryTableDataController<SettingsCell>(
            tableView: self.tableView,
            fetchRequest: dao.list(),
            context: context,
            convert: { (dao.entityToModel($0), self.navigation) }
        )
    }
    
    @objc func addPressed(_ sender: Any) {
        //let ui = GroupAddViewController(navigation: self.navigation)
        let ui = OrgListViewController()
        self.navigation.pushViewController(ui, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
