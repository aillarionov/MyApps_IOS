//
//  OrgItemDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData
import UIKit

class OrgItemDAO<T: OrgItem>: CommonDAO<T> {

    override internal func getByModelId(_ model: T) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: self.entityPK + " = %d", model.id)
        return request
    }
    
    override internal func modelIsEntity(model: T, entity: NSManagedObject) -> Bool {
        return model.id == entity.value(forKey: "id") as! Int
    }
    
    
    public func replace(forOrg orgId: Int,  _ items: [T]) {
        self.replace(items, request: self.list(forOrg: orgId))
    }
    
    public func list(forOrg id: Int) -> [T] {
        return self.list(request: self.list(forOrg: id))
    }
    
    public func list(forOrg id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "orgId = %d", id)
        request.sortDescriptors = [NSSortDescriptor(key: self.entityPK, ascending: true)]
        return request
    }
    
    public func delete(forOrg id: Int) {
        self.delete(request: self.list(forOrg: id))
    }
    
    public func get(_ id: Int) -> T? {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
            request.predicate = NSPredicate(format: self.entityPK + " = %d", id)
            let result = try self.context.fetch(request)
            return (result.first != nil ? self.entityToModel(result.first as! NSManagedObject) : nil)
        } catch {
            print("DAO [" + self.entityName + "] get error")
        }
        
        return nil
    }
    
}
