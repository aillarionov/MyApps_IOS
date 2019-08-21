//
//  FavoriteDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class FavoriteDAO: CommonDAO<Favorite> {

    let itemDAO: CatalogItemDAO
    let memberDAO: CatalogMemberDAO
    let imageDAO: CatalogImageDAO
    let newsDAO: CatalogNewsDAO
    
    override init(context: NSManagedObjectContext) {
        itemDAO = CatalogItemDAO(context: context)
        memberDAO = CatalogMemberDAO(context: context)
        imageDAO = CatalogImageDAO(context: context)
        newsDAO = CatalogNewsDAO(context: context)
        
        super.init(context: context)

        self.entityName = "Favorite"
    }
    
    override internal func entityToModel(_ entity: NSManagedObject) -> Favorite {
        return Favorite(
            id: entity.value(forKey: "id") as! String,
            itemId: entity.value(forKey: "itemId") as! Int,
            orgId: entity.value(forKey: "orgId") as! Int,
            catalogId: entity.value(forKey: "catalogId") as! Int,
            item: self.getItem(entity)
        )
    }
    
    private func getItem(_ entity: NSManagedObject) -> CatalogAbstractItem? {
        let i: NSManagedObject? =
            (entity.value(forKey: "item") as! [NSManagedObject]).first ??
            (entity.value(forKey: "member") as! [NSManagedObject]).first ??
            (entity.value(forKey: "image") as! [NSManagedObject]).first ??
            (entity.value(forKey: "news") as! [NSManagedObject]).first
        
        guard let item = i else { return nil }
        
        let type: String = item.entity.name!.replacingOccurrences(of: "Catalog", with: "").lowercased()
        
        switch CatalogType(rawValue: type)! {
        case .Item:
            return self.itemDAO.entityToModel(item)
        case .Member:
            return self.memberDAO.entityToModel(item)
        case .Image:
            return self.imageDAO.entityToModel(item)
        case .News:
            return self.newsDAO.entityToModel(item)
        }
        
    }
  
    override internal func applyModelToEntity(model: Favorite, entity: NSManagedObject) {
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.itemId, forKey: "itemId")
        entity.setValue(model.orgId, forKey: "orgId")
        entity.setValue(model.catalogId, forKey: "catalogId")
    }
    
    override internal func getByModelId(_ model: Favorite) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: self.entityPK + " = %@", model.id)
        return request
    }
    
    override internal func modelIsEntity(model: Favorite, entity: NSManagedObject) -> Bool {
        return model.id == entity.value(forKey: "id") as! String
    }
    
    public func get(_ id: String) -> Favorite? {
        let entity: NSManagedObject? = self.get(id)
        return entity != nil ? self.entityToModel(entity!) : nil
    }
    
    private func get(_ id: String) -> NSManagedObject? {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
            request.predicate = NSPredicate(format: self.entityPK + " = %@", id)
            let result = try self.context.fetch(request) as! [NSManagedObject]
            return result.first
        } catch {
            print("DAO [" + self.entityName + "] get error")
        }
        
        return nil
    }
    
    public func create(from item: CatalogAbstractItem) {
        let favorite = Favorite(id: item.id, itemId: item.itemId, orgId: item.orgId, catalogId: item.catalogId, item: nil)
        self.update(favorite)
    }

    public func delete(by item: CatalogAbstractItem) {
        guard let favorite: NSManagedObject = self.get(item.id) else { return }
        self.context.delete(favorite)
    }
    
    public func list(forOrg id: Int) -> [Favorite] {
        return self.list(request: self.list(forOrg: id))
    }
    
    public func list(forOrg id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "orgId = %d", id)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return request
    }
    
    public func delete(forOrg id: Int) {
        self.delete(request: self.list(forOrg: id))
    }
    
}
