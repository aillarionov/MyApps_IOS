//
//  CatalogMemberListViewController.swift
//  Inform
//
//  Created by Александр on 28.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class CatalogMemberListViewController: UIViewController,  UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var category: UITextField!
    
    private static let allCategories = NSLocalizedString("<ALL>", comment: "All categories in member screen")
    
    let navigation: UINavigationController
    let catalogId: Int
    let dao: CatalogMemberDAO
    var dc: MultiQueryTableDataController<CatalogMemberCell>?
    var currentCategory: String = CatalogMemberListViewController.allCategories
    
    init(catalogId: Int, navigation: UINavigationController) {
        self.catalogId = catalogId
        self.navigation = navigation
        
        let context = Globals.getViewContext()
        self.dao = CatalogMemberDAO(context: context)
        
        super.init(nibName: "CatalogMemberListViewController", bundle: nil)
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

        
        self.searchBar.inputAccessoryView = self.getKeyboardToolbar()
        
        let context = Globals.getViewContext()
        
        self.dc = MultiQueryTableDataController<CatalogMemberCell>(
            tableView: self.tableView,
            context: context
        )

        let members: [CatalogMember] = dao.list(forCatalog: self.catalogId)
        var categories = Array(Set(members.map { $0.categories }.joined())).filter { !$0.isEmpty }
        categories.insert(CatalogMemberListViewController.allCategories, at: 0)
        
        self.category.loadDropdownData(categories, onSelect: self.categoryChanged)
        
        self.dc?.onCellSelected = self.onItemSelected
        
        self.search()
    }

    func categoryChanged(category: String) {
        self.currentCategory = category
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search), object: self.searchBar)
        self.perform(#selector(self.search), with: self.searchBar, afterDelay: 0.5)
    }
    
    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search), object: self.searchBar)
        self.perform(#selector(self.search), with: self.searchBar, afterDelay: 0.5)
    }
    
    @objc private func search() {
        DispatchQueue.main.async {
            let query = self.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let category = self.currentCategory != CatalogMemberListViewController.allCategories ? self.currentCategory : ""

            self.dc?.clearSections()
            
            self.dc?.addSection(
                fetchRequest: self.dao.list(forCatalog: self.catalogId, withQuery: query, withCategory: category),
                convert: { self.dao.entityToModel($0) }
            )
        }
    }
    
    private func onItemSelected(index: Int, data: CatalogMember) {
        let showUI = CatalogMemberViewController(item: data, navigation: self.navigation)
        self.navigation.pushViewController(showUI, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
