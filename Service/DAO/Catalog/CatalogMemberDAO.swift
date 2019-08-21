//
//  CatalogMemberDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class CatalogMemberDAO: CatalogAbstractItemDAO<CatalogMember> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "CatalogMember"
    }
    
    internal func packArray(_ categories: [String]) -> String {
        var s: String = ""
        
        for category in categories {
            s += "[" + category + "]"
        }
        
        return s
    }
    
    internal func unpackArray(_ categories: String) -> [String] {
        return categories.trimmingCharacters(in: ["[", "]"]).components(separatedBy: "][")
    }
    
    override internal func entityToModel(_ entity: NSManagedObject) -> CatalogMember {
        return CatalogMember(
            id: entity.value(forKey: "id") as! String,
            itemId: entity.value(forKey: "itemId") as! Int,
            orgId: entity.value(forKey: "orgId") as! Int,
            catalogId: entity.value(forKey: "catalogId") as! Int,

            order:  entity.value(forKey: "order") as! Int,

            text: entity.value(forKey: "text") as! String,
            raw: entity.value(forKey: "raw") as! String,
            date: entity.value(forKey: "date") as! Date,
            
            pictures: entity.value(forKey: "pictures") as! [Picture],
            
            name: entity.value(forKey: "name") as! String?,
            stand: entity.value(forKey: "stand") as! String?,

            categories: self.unpackArray(entity.value(forKey: "categories") as! String),

            emails: entity.value(forKey: "emails") as! [String],
            phones: entity.value(forKey: "phones") as! [String],
            sites: entity.value(forKey: "sites") as! [String],
            vks: entity.value(forKey: "vks") as! [String],
            fbs: entity.value(forKey: "fbs") as! [String],
            insts: entity.value(forKey: "insts") as! [String],
            
            favorite: !(entity.value(forKey: "favorite") as! [NSManagedObject]).isEmpty
        )
    }
    
    override internal func applyModelToEntity(model: CatalogMember, entity: NSManagedObject) {
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.itemId, forKey: "itemId")
        entity.setValue(model.orgId, forKey: "orgId")
        entity.setValue(model.catalogId, forKey: "catalogId")

        entity.setValue(model.order, forKey: "order")

        entity.setValue(model.text, forKey: "text")
        entity.setValue(model.raw.lowercased(), forKey: "raw")
        entity.setValue(model.date, forKey: "date")
        
        entity.setValue(model.name, forKey: "name")
        entity.setValue(model.stand, forKey: "stand")
        
        entity.setValue(self.packArray(model.categories), forKey: "categories")
        
        entity.setValue(model.emails, forKey: "emails")
        entity.setValue(model.phones, forKey: "phones")
        entity.setValue(model.sites, forKey: "sites")
        entity.setValue(model.vks, forKey: "vks")
        entity.setValue(model.fbs, forKey: "fbs")
        entity.setValue(model.insts, forKey: "insts")
        
        entity.setValue(model.pictures, forKey: "pictures")
    }
    
    public func list(forCatalog id: Int, withQuery query: String, withCategory category: String) -> NSFetchRequest<NSFetchRequestResult> {
        let cat = category.isEmpty ? "*" : "*["+category+"]*" 
        let q = "*" + query.lowercased() + "*"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "catalogId = %d and raw like %@ and categories like %@", argumentArray: [id, q, cat])
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true), NSSortDescriptor(key: "id", ascending: false)]
        return request
    }
    
}
