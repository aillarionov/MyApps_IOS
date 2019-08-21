//
//  CommonDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData
import UIKit

class CommonDAO<T> {

    public var entityName: String = ""
    public var entityPK: String = "id"
    
    public var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func getByModelId(_ model: T) -> NSFetchRequest<NSFetchRequestResult> {
        preconditionFailure("This method must be overridden")
    }
    
    internal func modelIsEntity(model: T, entity: NSManagedObject) -> Bool {
        preconditionFailure("This method must be overridden")
    }
    
    internal func entityToModel(_ entity: NSManagedObject) -> T {
        preconditionFailure("This method must be overridden")
    }
    
    internal func applyModelToEntity(model: T, entity: NSManagedObject) {
        preconditionFailure("This method must be overridden")
    }
    
    public func list() -> [T] {
        return list(request: self.list())
    }
    
    public func list() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: self.entityPK, ascending: true)]
        return request
    }
    
    public func list(request: NSFetchRequest<NSFetchRequestResult>) -> [T] {
        do {
            let result = try self.context.fetch(request)
            
            var models: [T] = []
            for data in result as! [NSManagedObject] {
                models.append(self.entityToModel(data))
            }
            return models
        } catch {
            print("DAO [" + self.entityName + "] list error")
        }
        
        return []
    }
    
    public func update(_ item: T) {
        self.update(item, true)
    }
    
    public func update(_ item: T, _ overwrite: Bool) {
        if let entity = self.getExist(item) {
            if overwrite {
                self.applyModelToEntity(model: item, entity: entity)
            }
        } else {
            let description = NSEntityDescription.entity(forEntityName: self.entityName, in: self.context)
            let entity = NSManagedObject(entity: description!, insertInto: self.context)
            self.applyModelToEntity(model: item, entity: entity)
        }
    }
    
    public func replace(_ items: [T], request: NSFetchRequest<NSFetchRequestResult>) {
        do {
            
            var entities = try self.context.fetch(request) as! [NSManagedObject]
            
            for item in items {
                var found = false
                
                for (index, entity) in entities.enumerated() {
                    if self.modelIsEntity(model: item, entity: entity) {
                        // Found - update
                        self.applyModelToEntity(model: item, entity: entity)
                        entities.remove(at: index)
                        found = true
                        break
                    }
                }
                
                // Not found - new
                if !found {
                    let description = NSEntityDescription.entity(forEntityName: self.entityName, in: self.context)
                    let entity = NSManagedObject(entity: description!, insertInto: self.context)
                    self.applyModelToEntity(model: item, entity: entity)
                }
            }
            
            // Clean not exists
            for entity in entities {
                self.context.delete(entity)
            }
            
        } catch {
            print("DAO [" + self.entityName + "] replace error")
        }
    }
    
    public func replace(_ items: [T]) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        self.replace(items, request: request)
    }
    
    public func delete(_ item: T) {
        if let entity = self.getExist(item) {
            self.context.delete(entity)
        }
    }
    
    public func delete(request: NSFetchRequest<NSFetchRequestResult>) {
        do {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try self.context.execute(deleteRequest)
        } catch {
            print("DAO [" + self.entityName + "] delete error")
        }
    }
    
    public func getExist(_ model: T) -> NSManagedObject? {
        do {
            let request = self.getByModelId(model)
            let result = try self.context.fetch(request)
            return result.first as? NSManagedObject
        } catch {
            print("DAO [" + self.entityName + "] get error")
        }
        
        return nil
    }
    
    public func upVer(_ item: T) {
        if let entity = self.getExist(item) {
            entity.setValue(entity.value(forKey: "ver") as! Int + 1, forKey: "ver")
        }
    }
}
