//
//  NotificationProcessor.swift
//  Inform
//
//  Created by Александр on 26.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class NotificationProcessor {

    let rootView: UIViewController
    
    var lc: Cancelable?
    
    init (rootView: UIViewController) {
        self.rootView = rootView
    }
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func processMessage(_ payload: NotificationPayload) {
        if let news = payload.news {
            self.processNews(news)
        }
            
    }
    
    func processNews(_ news: NotificationNews) {
        let worker = DataWorker()
        let context = worker.begin()
        
        if /*let settings: Settings = SettingsDAO(context: context).get(news.orgId),*/
            let catalog: Catalog = CatalogDAO(context: context).get(news.catalogId) {

            self.lc = LocalDataStore.refreshCatalogItems(
                catalog,
                context: context,
                success: {
                    do {
                        try worker.commmit()
                        
                        let news = CatalogNewsDAO(context: Globals.getViewContext()).get(orgId: news.orgId, catalogId: news.catalogId, itemId: news.itemId)

                        if news != nil {
                            self.showNews(news!)
                        }
                    } catch let error {
                        print(error)
                    }
                },
                failure: {
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
    
    func showNews(_ news: CatalogNews) {
        DispatchQueue.main.async {
            let navigation = UINavigationController()
            
            let view = CatalogNewsViewController(item: news, navigation: navigation)
            
            let buttonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: ""), style: .plain, target: self, action: #selector(self.close))
            
            view.navigationItem.rightBarButtonItem = buttonItem
            
            UIApplication.shared.keyWindow?.rootViewController = navigation

            navigation.pushViewController(view, animated: true)
        }
    }

    @objc func close() {
        UIApplication.shared.keyWindow?.rootViewController = self.rootView
    }
    
}
