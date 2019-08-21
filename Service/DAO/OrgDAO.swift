//
//  OrgDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class OrgDAO: CommonDAO<Org> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "Org"
    }
    
    override internal func entityToModel(_ entity: NSManagedObject) -> Org {
        return Org(
            id: entity.value(forKey: "id") as! Int,
            name: entity.value(forKey: "name") as! String,
            logo: entity.value(forKey: "logo") as! String,
            city: entity.value(forKey: "city") as! City?
        )
    }
    
    override internal func applyModelToEntity(model: Org, entity: NSManagedObject) {
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.name, forKey: "name")
        entity.setValue(model.logo, forKey: "logo")
        entity.setValue(model.city, forKey: "city")
    }
    
    override internal func getByModelId(_ model: Org) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: self.entityPK + " = %d", model.id)
        return request
    }
    
    override internal func modelIsEntity(model: Org, entity: NSManagedObject) -> Bool {
        return model.id == entity.value(forKey: "id") as! Int
    }
    
}
