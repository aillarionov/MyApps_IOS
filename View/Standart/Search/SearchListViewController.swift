//
//  SearchListViewController.swift
//  Inform
//
//  Created by Александр on 28.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class SearchListViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let navigation: UINavigationController
    let orgId: Int
    
    var dc: MultiQueryTableDataController<AbstractItemCell>?
    
    let itemDAO: CatalogItemDAO
    let memberDAO: CatalogMemberDAO
    let newsDAO: CatalogNewsDAO

    
    init(orgId: Int, navigation: UINavigationController) {
        self.orgId = orgId
        self.navigation = navigation
        
        let context = Globals.getViewContext()
        itemDAO = CatalogItemDAO(context: context)
        memberDAO = CatalogMemberDAO(context: context)
        newsDAO = CatalogNewsDAO(context: context)
        
        super.init(nibName: "SearchListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        self.searchBar.inputAccessoryView = self.getKeyboardToolbar()
        
        self.dc = MultiQueryTableDataController<AbstractItemCell>(
            tableView: self.tableView,
            context: Globals.getViewContext()
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
    
    @objc private func search(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.dc?.clearSections()
            
            let q = searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.dc?.addSection(
                fetchRequest: self.itemDAO.list(forOrg: self.orgId, withQuery: q),
                convert: { self.itemDAO.entityToModel($0) }
            )
            
            self.dc?.addSection(
                fetchRequest: self.memberDAO.list(forOrg: self.orgId, withQuery: q),
                convert: { self.memberDAO.entityToModel($0) }
            )

            self.dc?.addSection(
                fetchRequest: self.newsDAO.list(forOrg: self.orgId, withQuery: q),
                convert: { self.newsDAO.entityToModel($0) }
            )
        }
    }
    
    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search(_:)), object: searchBar)
        self.perform(#selector(self.search(_:)), with: searchBar, afterDelay: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
