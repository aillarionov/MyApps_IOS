//
//  CatalogDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class CatalogDAO: OrgItemDAO<Catalog> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "Catalog"
    }
    
    override internal func entityToModel(_ entity: NSManagedObject) -> Catalog {
        return Catalog(
            orgId: entity.value(forKey: "orgId") as! Int,
            id: entity.value(forKey: "id") as! Int,
            lastChange: entity.value(forKey: "lastChange") as! Date,
            type: CatalogType(rawValue: entity.value(forKey: "type") as! String)!,
            presenterVisible: entity.value(forKey: "presenterVisible") as! Bool,
            visitorVisible: entity.value(forKey: "visitorVisible") as! Bool
        )
    }
    
    override internal func applyModelToEntity(model: Catalog, entity: NSManagedObject) {
        entity.setValue(model.orgId, forKey: "orgId")
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.lastChange, forKey: "lastChange")
        entity.setValue(model.type.rawValue, forKey: "type")
        entity.setValue(model.presenterVisible, forKey: "presenterVisible")
        entity.setValue(model.visitorVisible, forKey: "visitorVisible")
    }
    
}
