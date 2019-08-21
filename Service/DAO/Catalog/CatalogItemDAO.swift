//
//  CatalogItemDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class CatalogItemDAO: CatalogAbstractItemDAO<CatalogItem> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "CatalogItem"
    }
    
    override internal func entityToModel(_ entity: NSManagedObject) -> CatalogItem {
        return CatalogItem(
            id: entity.value(forKey: "id") as! String,
            itemId: entity.value(forKey: "itemId") as! Int,
            orgId: entity.value(forKey: "orgId") as! Int,
            catalogId: entity.value(forKey: "catalogId") as! Int,

            order:  entity.value(forKey: "order") as! Int,
            
            text: entity.value(forKey: "text") as! String,
            raw: entity.value(forKey: "raw") as! String,
            date: entity.value(forKey: "date") as! Date,
            
            pictures: entity.value(forKey: "pictures") as! [Picture],
            
            favorite: !(entity.value(forKey: "favorite") as! [NSManagedObject]).isEmpty
        )
    }
    
    override internal func applyModelToEntity(model: CatalogItem, entity: NSManagedObject) {
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.itemId, forKey: "itemId")
        entity.setValue(model.orgId, forKey: "orgId")
        entity.setValue(model.catalogId, forKey: "catalogId")

        entity.setValue(model.order, forKey: "order")

        entity.setValue(model.text, forKey: "text")
        entity.setValue(model.raw.lowercased(), forKey: "raw")
        entity.setValue(model.date, forKey: "date")
        
        entity.setValue(model.pictures, forKey: "pictures")
    }
    
}
