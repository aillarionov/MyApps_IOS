//
//  CatalogImageDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class CatalogImageDAO: CatalogAbstractItemDAO<CatalogImage> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "CatalogImage"
    }
    
     override internal func entityToModel(_ entity: NSManagedObject) -> CatalogImage {
        return CatalogImage(
            id: entity.value(forKey: "id") as! String,
            itemId: entity.value(forKey: "itemId") as! Int,
            orgId: entity.value(forKey: "orgId") as! Int,
            catalogId: entity.value(forKey: "catalogId") as! Int,

            order:  entity.value(forKey: "order") as! Int,

            date: entity.value(forKey: "date") as! Date,
            
            pictures: entity.value(forKey: "pictures") as! [Picture],
            
            favorite: !(entity.value(forKey: "favorite") as! [NSManagedObject]).isEmpty
        )
    }
    
    override internal func applyModelToEntity(model: CatalogImage, entity: NSManagedObject) {
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.itemId, forKey: "itemId")
        entity.setValue(model.orgId, forKey: "orgId")
        entity.setValue(model.catalogId, forKey: "catalogId")

        entity.setValue(model.order, forKey: "order")

        entity.setValue(model.date, forKey: "date")
        
        entity.setValue(model.pictures, forKey: "pictures")
    }
    
}
