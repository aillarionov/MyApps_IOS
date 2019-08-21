//
//  LocalDataStore.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class LocalDataStore: Any {
    
    public static func loadOrg(_ orgId: Int, success: @escaping (() -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        let cancelable = Cancelable { failure(ErrorCanceled()) }
        
        let rs = RemoteService.getOrg(
            orgId: orgId,
            success: { response in
                if cancelable.isCanceled() { return }
                
                let worker = DataWorker()
                let context = worker.begin()

                if cancelable.isCanceled() { do { try worker.rollback() } catch let error { print(error) } ; return }

                // Org
                let org = OrgDTO.toModel(fromProxy: response.data)
                OrgDAO(context: context).update(org)
                if cancelable.isCanceled() { do { try worker.rollback() } catch let error { print(error) } ; return }
                
                // Catalogs
                let catalogs = response.data.catalogs.map{ CatalogDTO.toModel(fromProxy: $0, orgId: response.data.id) }
                CatalogDAO(context: context).replace(forOrg: response.data.id, catalogs)
                if cancelable.isCanceled() { do { try worker.rollback() } catch let error { print(error) } ; return }
                
                // MenuItems
                let menuItems = response.data.menuItems.map{ MenuItemDTO.toModel(fromProxy: $0, orgId: response.data.id) }
                MenuItemDAO(context: context).replace(forOrg: response.data.id, menuItems)
                if cancelable.isCanceled() { do { try worker.rollback() } catch let error { print(error) } ; return }
                
                // Forms
                let forms = response.data.forms.map{ FormDTO.toModel(fromProxy: $0, orgId: response.data.id) }
                FormDAO(context: context).replace(forOrg: response.data.id, forms)
                if cancelable.isCanceled() { do { try worker.rollback() } catch let error { print(error) } ; return }
                
                // FormItems
                var formItems: [FormItem] = []
                for form in response.data.forms {
                    let items = form.items.map{ FormItemDTO.toModel(fromProxy: $0, orgId: response.data.id, formId: form.id) }
                    formItems.append(contentsOf: items)
                }
                FormItemDAO(context: context).replace(forOrg: response.data.id, formItems)
                if cancelable.isCanceled() { do { try worker.rollback() } catch let error { print(error) } ; return }
                
                // Ticket
                let ticket = (response.data.ticket != nil ? TicketDTO.toModel(fromProxy: response.data.ticket!, orgId: response.data.id) : nil)
                TicketDAO(context: context).update(ticket, response.data.id)
                if cancelable.isCanceled() { do { try worker.rollback() } catch let error { print(error) } ; return }
                
                // Settings
                let settings = Settings(
                    id: response.data.id,
                    isVisitor: true,
                    isPresenter: false,
                    receiveNotifications: true,
                    org: org
                )
                SettingsDAO(context: context).update(settings, false)
                if cancelable.isCanceled() { do { try worker.rollback() } catch let error { print(error) } ; return }

                // Catalogs
                let lc = self.loadCatalogs(
                    catalogs,
                    context: context,
                    success: {
                        if cancelable.isCanceled() { do { try worker.rollback() } catch let error { print(error) } ; return }
                        
                        do {
                            try worker.commmit()
                            success()
                            DispatchQueue.main.async {
                                (UIApplication.shared.delegate as! AppDelegate).sendClientData()
                            }
                        } catch let error {
                            failure(error)
                        }
                    },
                    failure: {
                        do {
                            try worker.rollback();
                        } catch let error2 {
                            print(error2)
                        }
                        
                        failure($0)
                    }
                )
                
                cancelable.addCancel { lc.cancel() }
            
            },
            failure: { error in
                failure(error)
            }
        )
        
        cancelable.addCancel { rs.cancel() }
        
        return cancelable
    }
    
    public static func getCatalogNews(catalogId: Int, context: NSManagedObjectContext, success: @escaping (([CatalogNews]) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        let cancelable = Cancelable { failure(ErrorCanceled()) }

        DispatchQueue.global(qos: .userInitiated).async {
            let dao = CatalogNewsDAO(context: context)
        
            if !cancelable.isCanceled() {
                success(dao.list(forCatalog: catalogId))
            }
        }
        return cancelable
    }
    
    public static func getMenuItems(orgId: Int, context: NSManagedObjectContext, success: @escaping (([MenuItem]) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        let cancelable = Cancelable { failure(ErrorCanceled()) }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let dao = MenuItemDAO(context: context)
            
            if !cancelable.isCanceled() {
                success(dao.list(forOrg: orgId))
            }
        }
        return cancelable
    }
    
    private static func loadCatalogs(_ catalogs: [Catalog], context: NSManagedObjectContext, success: @escaping (() -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let cancelable = Cancelable()
        let progress = AtomicInteger(value: catalogs.count)
        
        if catalogs.count == 0 {
            success()
        }
        
        for catalog in catalogs {
            let lci = self.refreshCatalogItems(
                catalog,
                context: context,
                success: {
                    if progress.decrementAndGet() == 0 {
                        success()
                    }
                },
                failure: { failure($0) }
            )
            
            cancelable.addCancel { lci.cancel() }
        }
        
        
        return cancelable
    }
    
    public static func refreshCatalogItems(_ catalog: Catalog, context: NSManagedObjectContext, success: @escaping (() -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        let cancelable = Cancelable { failure(ErrorCanceled()) }
        
        let rs = RemoteService.getCatalogLastModified(
            catalogId: catalog.id,
            success: { response in
                if cancelable.isCanceled() { return }
                
                if response.data.asDate() == nil || response.data.asDate() != catalog.lastChange {
                    let lci = self.loadCatalogItems(catalog, context: context, success: success, failure: failure)
                    cancelable.addCancel { lci.cancel() }
                } else {
                    success()
                }
            },
            failure: { failure($0) }
        )
        
        cancelable.addCancel { rs.cancel(); }
        
        return cancelable
    }
    
    private static func loadCatalogItems(_ catalog: Catalog, context: NSManagedObjectContext, success: @escaping (() -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {

        var catalog = catalog
        
        switch catalog.type {

        case .Item:
            return RemoteService.getCatalogItems(
                type: CatalogItemProxy.self,
                catalogId: catalog.id,
                success: {
                    let items = $0.data.enumerated().map { (i, p) in return CatalogItemDTO.toModel(fromProxy: p, orgId: catalog.orgId, catalogId: catalog.id, order: i) }
                    CatalogItemDAO(context: context).replace(forCatalog: catalog.id, items)
                    
                    catalog.lastChange = $0.lastChange ?? Date.min
                    CatalogDAO(context: context).update(catalog)
                    
                    success()
                },
                failure: { failure($0) }
            )
            
        case .Member:
            return RemoteService.getCatalogItems(
                type: CatalogMemberProxy.self,
                catalogId: catalog.id,
                success: {
                    let items = $0.data.enumerated().map { (i, p) in return CatalogMemberDTO.toModel(fromProxy: p, orgId: catalog.orgId, catalogId: catalog.id, order: i) }
                    CatalogMemberDAO(context: context).replace(forCatalog: catalog.id, items)
                    
                    catalog.lastChange = $0.lastChange ?? Date.min
                    CatalogDAO(context: context).update(catalog)
                    
                    success()
                },
                failure: { failure($0) }
            )
            
        case .Image:
            return RemoteService.getCatalogItems(
                type: CatalogImageProxy.self,
                catalogId: catalog.id,
                success: {
                    let items = $0.data.enumerated().map { (i, p) in return CatalogImageDTO.toModel(fromProxy: p, orgId: catalog.orgId, catalogId: catalog.id, order: i) }
                    CatalogImageDAO(context: context).replace(forCatalog: catalog.id, items)
                    
                    catalog.lastChange = $0.lastChange ?? Date.min
                    CatalogDAO(context: context).update(catalog)
                    
                    success()
                },
                failure: { failure($0) }
            )
            
        case .News:
            return RemoteService.getCatalogItems(
                type: CatalogNewsProxy.self,
                catalogId: catalog.id,
                success: {
                    let items = $0.data.enumerated().map { (i, p) in return CatalogNewsDTO.toModel(fromProxy: p, orgId: catalog.orgId, catalogId: catalog.id, order: i) }
                    CatalogNewsDAO(context: context).replace(forCatalog: catalog.id, items)
                    
                    catalog.lastChange = $0.lastChange ?? Date.min
                    CatalogDAO(context: context).update(catalog)
                    
                    success()
                },
                failure: { failure($0) }
            )
        
        }
    }
    
    public static func deleteOrg(_ org: Org) throws {
        
        do {
            try ImageStoreService.clearImages(forOrg: org.id, storeType: .Temporary)
        } catch let error {
            print(error)
        }
        do {
            try ImageStoreService.clearImages(forOrg: org.id, storeType: .Permanent)
        } catch let error {
            print(error)
        }
        do {
            try ImageStoreService.clearImages(forOrg: org.id, storeType: .System)
        } catch let error {
            print(error)
        }
        
        let worker = DataWorker()
        let context = worker.begin()
        
        FavoriteDAO(context: context).delete(forOrg: org.id)
        
        CatalogItemDAO(context: context).delete(forOrg: org.id)
        CatalogMemberDAO(context: context).delete(forOrg: org.id)
        CatalogNewsDAO(context: context).delete(forOrg: org.id)
        CatalogImageDAO(context: context).delete(forOrg: org.id)
        
        FormItemDAO(context: context).delete(forOrg: org.id)
        FormDAO(context: context).delete(forOrg: org.id)
        MenuItemDAO(context: context).delete(forOrg: org.id)
        CatalogDAO(context: context).delete(forOrg: org.id)
        SettingsDAO(context: context).delete(forOrg: org.id)
        TicketDAO(context: context).delete(forOrg: org.id)
        
        
        OrgDAO(context: context).delete(org)
        
        try worker.commmit()
        
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as! AppDelegate).sendClientData()
        }
    }
    
    static func storeOrgImages(_ orgId: Int, success: @escaping (() -> Void),  failure: @escaping ((Error) -> Void), progress: @escaping ((Int, Int) -> Void)) -> Cancelable {
        
        let cancelable = Cancelable { failure(ErrorCanceled()) }
        
        DispatchQueue.global(qos: .background).async {
            var images: [Image] = []
            let context = Globals.getViewContext()
        
            if cancelable.isCanceled() { return }
            images.append(contentsOf: CatalogItemDAO(context: context).list(forOrg: orgId).flatMap{ $0.pictures }.flatMap{ $0.images })

            if cancelable.isCanceled() { return }
            images.append(contentsOf: CatalogMemberDAO(context: context).list(forOrg: orgId).flatMap{ $0.pictures }.flatMap{ $0.images })
            
            if cancelable.isCanceled() { return }
            images.append(contentsOf: CatalogImageDAO(context: context).list(forOrg: orgId).flatMap{ $0.pictures }.flatMap{ $0.images })
            
            if cancelable.isCanceled() { return }
            images.append(contentsOf: CatalogNewsDAO(context: context).list(forOrg: orgId).flatMap{ $0.pictures }.flatMap{ $0.images })

            if cancelable.isCanceled() { return }

            for (i, image) in images.enumerated() {
                if let url =  URL(string: image.source) {
                    _ = ImageStoreService.getImageSync(fromUrl: url, orgId: orgId, storeType: .Temporary)
                }
                progress(i, images.count)
            }
            
            success()
        }
        
        return cancelable
    }
    
    public static func hasOrgs() -> Bool {
        return SettingsDAO(context: Globals.getViewContext()).list().count > 0
    }
    
}
