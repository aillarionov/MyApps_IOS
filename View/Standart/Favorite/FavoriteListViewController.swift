//
//  FavoriteListViewController.swift
//  Inform
//
//  Created by Александр on 28.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class FavoriteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let navigation: UINavigationController
    let orgId: Int
    
    var dc: QueryTableDataController<AbstractItemCell>?
    
    init(orgId: Int, navigation: UINavigationController) {
        self.orgId = orgId
        self.navigation = navigation
        super.init(nibName: "FavoriteListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        let context = Globals.getViewContext()
        let dao = FavoriteDAO(context: context)
        
        self.dc = QueryTableDataController<AbstractItemCell>(
            tableView: self.tableView,
            fetchRequest: dao.list(forOrg: self.orgId),
            context: context,
            convert: { dao.entityToModel($0).item! }
        )
        
        self.dc?.onCellSelected = self.onItemSelected
    }

    private func onItemSelected(index: Int, data: CatalogAbstractItem) {
        var showUI: UIViewController
        
        switch data.catalogType {
        case .Item:
            showUI = CatalogItemViewController(item: data as! CatalogItem, navigation: self.navigation)
        case .Member:
            showUI = CatalogMemberViewController(item: data as! CatalogMember, navigation: self.navigation)
        case .Image:
            showUI = CatalogImageViewController(item: data as! CatalogImage, navigation: self.navigation)
        case .News:
            showUI = CatalogNewsViewController(item: data as! CatalogNews, navigation: self.navigation)
        }
        
        self.navigation.pushViewController(showUI, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
