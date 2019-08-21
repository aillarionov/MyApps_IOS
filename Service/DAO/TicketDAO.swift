//
//  TicketDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class TicketDAO: CommonDAO<Ticket> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "Ticket"
    }

    override internal func entityToModel(_ entity: NSManagedObject) -> Ticket {
        return Ticket(
            id: entity.value(forKey: "id") as! Int,
            type: TicketType(rawValue: entity.value(forKey: "type") as! String)!,
            source: entity.value(forKey: "source") as! String?,
            text: entity.value(forKey: "text") as! String?,
            button: entity.value(forKey: "button") as! String?
        )
    }
    
    override internal func applyModelToEntity(model: Ticket, entity: NSManagedObject) {
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.type.rawValue, forKey: "type")
        entity.setValue(model.source, forKey: "source")
        entity.setValue(model.text, forKey: "text")
        entity.setValue(model.button, forKey: "button")
    }
    
    override internal func getByModelId(_ model: Ticket) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: self.entityPK + " = %d", model.id)
        return request
    }
    
    override internal func modelIsEntity(model: Ticket, entity: NSManagedObject) -> Bool {
        return model.id == entity.value(forKey: "id") as! Int
    }
    
    public func get(_ id: Int) -> Ticket? {
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
    
    public func update(_ item: Ticket?, _ orgId: Int) {
        if let item = item {
            self.update(item)
        } else {
            if let item = self.get(orgId) {
                self.delete(item)
            }
        }
    }
    
    public func delete(forOrg id: Int) {
        if let ticket = self.get(id) {
            self.delete(ticket)
        }
    }
    
}
