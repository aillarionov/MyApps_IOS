//
//  SettingsDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class SettingsDAO: CommonDAO<Settings> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "Settings"
    }
    
    override internal func entityToModel(_ entity: NSManagedObject) -> Settings {
        let org = (entity.value(forKey: "org") as! [NSManagedObject]).first
        
        return Settings(
            id: entity.value(forKey: "id") as! Int,
            isVisitor: entity.value(forKey: "isVisitor") as! Bool,
            isPresenter: entity.value(forKey: "isPresenter") as! Bool,
            receiveNotifications: entity.value(forKey: "receiveNotifications") as! Bool,
            org: org != nil ? OrgDAO(context: self.context).entityToModel(org!) : nil 
        )
    }
    
    override internal func applyModelToEntity(model: Settings, entity: NSManagedObject) {
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.isVisitor, forKey: "isVisitor")
        entity.setValue(model.isPresenter, forKey: "isPresenter")
        entity.setValue(model.receiveNotifications, forKey: "receiveNotifications")
    }
    
    override internal func getByModelId(_ model: Settings) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: self.entityPK + " = %d", model.id)
        return request
    }
    
    override internal func modelIsEntity(model: Settings, entity: NSManagedObject) -> Bool {
        return model.id == entity.value(forKey: "id") as! Int
    }
    
    public func get(_ id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: self.entityPK + " = %d", id)
        return request
    }
    
    public func get(_ id: Int) -> Settings? {
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
    
    public func delete(forOrg id: Int) {
        self.delete(request: self.get(id))
    }
    
}
