//
//  MenuListViewController.swift
//  Inform
//
//  Created by Александр on 26.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class MenuListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let items: [UIViewController]
    private let navigation: UINavigationController
    
    var dc: TableDataController<MenuItemViewCell>?
    
    init(items: [UIViewController], navigation: UINavigationController) {
        self.items = items
        self.navigation = navigation
        super.init(nibName: "MenuListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.compatibleIOS10()
        
        self.dc = TableDataController<MenuItemViewCell>(tableView: self.tableView)
        self.dc?.onCellSelected = self.onCellSelected
        self.dc?.setData(self.items)
    }
    
    private func onCellSelected(index: Int, data: UIViewController) {
        self.navigation.pushViewController(data, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
