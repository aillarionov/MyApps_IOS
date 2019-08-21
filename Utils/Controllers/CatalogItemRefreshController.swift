//
//  CatalogItemRefreshController.swift
//  Inform
//
//  Created by Александр on 02.04.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class CatalogItemRefreshController: UIRefreshControl {

    let catalogId: Int
    var lc: Cancelable?
    
    init(catalogId: Int) {
        self.catalogId = catalogId
        
        super.init()
        
        self.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleRefresh() {
        let worker = DataWorker()
        let context = worker.begin()
        
        
        if let catalog = CatalogDAO(context: context).get(self.catalogId) {
            self.lc = LocalDataStore.refreshCatalogItems(
                catalog,
                context: context,
                success: {
                    self.endRefreshing()
                    do {
                        try worker.commmit()
                    } catch let error {
                        print(error)
                    }
                },
                failure: {
                    self.endRefreshing()
                    do {
                        try worker.rollback()
                    } catch let error {
                        print(error)
                    }
                    print($0)
                }
            )
        }
    }
    
    override func endRefreshing() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                super.endRefreshing()
            }
        } else {
            super.endRefreshing()
        }
        
    }
    
    
}
