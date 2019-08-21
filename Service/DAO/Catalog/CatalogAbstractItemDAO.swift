//
//  CatalogAbstractItemDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData
import UIKit

class CatalogAbstractItemDAO<T: CatalogAbstractItem>: CommonDAO<T> {
    
    override internal func getByModelId(_ model: T) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: self.entityPK + " = %@", model.id)
        return request
    }
    
    override internal func modelIsEntity(model: T, entity: NSManagedObject) -> Bool {
        return model.id == entity.value(forKey: "id") as! String
    }
    
    public func get(_ id: String) -> T? {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
            request.predicate = NSPredicate(format: self.entityPK + " = %@", id)
            let result = try self.context.fetch(request)
            return (result.first != nil ? self.entityToModel(result.first as! NSManagedObject) : nil)
        } catch {
            print("DAO [" + self.entityName + "] get error")
        }
        
        return nil
    }
    
    public func get(orgId: Int, catalogId: Int, itemId: Int) -> T? {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
            request.predicate = NSPredicate(format: "orgId = %d and catalogId = %d and itemId = %d", orgId, catalogId, itemId)
            let result = try self.context.fetch(request)
            return (result.first != nil ? self.entityToModel(result.first as! NSManagedObject) : nil)
        } catch {
            print("DAO [" + self.entityName + "] get error")
        }
        
        return nil
    }
    
    public func replace(forCatalog catalogId: Int,  _ items: [T]) {
        self.replace(items, request: self.list(forCatalog: catalogId))
    }
    
    public func list(forCatalog id: Int) -> [T] {
        return self.list(request: self.list(forCatalog: id))
    }
    
    public func list(forCatalog id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "catalogId = %d", id)
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true), NSSortDescriptor(key: "id", ascending: false)]
        return request
    }
    
    public func list(forOrg id: Int) -> [T] {
        return self.list(request: self.list(forOrg: id))
    }
    
    public func list(forOrg id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "orgId = %d", id)
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true), NSSortDescriptor(key: "id", ascending: false)]
        return request
    }
    
    public func list(forOrg id: Int, withQuery query: String) -> NSFetchRequest<NSFetchRequestResult> {
        let q = "*" + query.lowercased() + "*"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "orgId = %d and raw like %@", argumentArray: [id, q])
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true), NSSortDescriptor(key: "id", ascending: false)]
        return request
    }
    
    public func delete(forOrg id: Int) {
        self.delete(request: self.list(forOrg: id))
    }

    
    
}
