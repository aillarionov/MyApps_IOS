//
//  CatalogImageListViewController.swift
//  Inform
//
//  Created by Александр on 28.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class CatalogImageListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let navigation: UINavigationController
    let catalogId: Int
    
    var dc: QueryTableDataController<CatalogImageCell>?
    
    init(catalogId: Int, navigation: UINavigationController) {
        self.catalogId = catalogId
        self.navigation = navigation
        super.init(nibName: "CatalogImageListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = CatalogItemRefreshController(catalogId: self.catalogId)
        } else {
            tableView.addSubview(CatalogItemRefreshController(catalogId: self.catalogId))
        }

        
        let context = Globals.getViewContext()
        let dao = CatalogImageDAO(context: context)
        
        self.dc = QueryTableDataController<CatalogImageCell>(
            tableView: self.tableView,
            fetchRequest: dao.list(forCatalog: self.catalogId),
            context: context,
            convert: { dao.entityToModel($0) }
        )
        
        self.dc?.onCellSelected = self.onItemSelected
    }

    private func onItemSelected(index: Int, data: CatalogImage) {
        let showUI = CatalogImageViewController(item: data, navigation: self.navigation)
        self.navigation.pushViewController(showUI, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
