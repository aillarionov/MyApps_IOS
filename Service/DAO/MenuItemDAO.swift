//
//  MenuItemDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class MenuItemDAO: OrgItemDAO<MenuItem> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "MenuItem"
    }
    
    override internal func entityToModel(_ entity: NSManagedObject) -> MenuItem {
        return MenuItem(
            orgId: entity.value(forKey: "orgId") as! Int,
            id: entity.value(forKey: "id") as! Int,
            name: entity.value(forKey: "name") as! String,
            icon: entity.value(forKey: "icon") as! String,
            type: MenuItemType(rawValue: entity.value(forKey: "type") as! String)!,
            params: entity.value(forKey: "params") as! [String : QuantumValue],
            order: entity.value(forKey: "order") as! Int
        )
    }
    
    override internal func applyModelToEntity(model: MenuItem, entity: NSManagedObject) {
        entity.setValue(model.orgId, forKey: "orgId")
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.name, forKey: "name")
        entity.setValue(model.icon, forKey: "icon")
        entity.setValue(model.type.rawValue, forKey: "type")
        entity.setValue(model.params, forKey: "params")
        entity.setValue(model.order, forKey: "order")
    }
    
    public override func list(forOrg id: Int) -> [MenuItem] {
        let request: NSFetchRequest<NSFetchRequestResult> = list(forOrg: id)
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        return list(request: request)
    }
    
}
