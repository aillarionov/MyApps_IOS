//
//  FormItemDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class FormItemDAO: OrgItemDAO<FormItem> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "FormItem"
    }
    
    override internal func entityToModel(_ entity: NSManagedObject) -> FormItem {
        return FormItem(
            orgId: entity.value(forKey: "orgId") as! Int,
            formId: entity.value(forKey: "formId") as! Int,
            id: entity.value(forKey: "id") as! Int,
            type: FormItemType(rawValue: entity.value(forKey: "type") as! String)!,
            name: entity.value(forKey: "name") as! String,
            title: entity.value(forKey: "title") as! String,
            required: entity.value(forKey: "required") as! Bool,
            params: entity.value(forKey: "params") as! [String : QuantumValue],
            order: entity.value(forKey: "order") as! Int
        )
    }
    
    override internal func applyModelToEntity(model: FormItem, entity: NSManagedObject) {
        entity.setValue(model.orgId, forKey: "orgId")
        entity.setValue(model.formId, forKey: "formId")
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.type.rawValue, forKey: "type")
        entity.setValue(model.name, forKey: "name")
        entity.setValue(model.title, forKey: "title")
        entity.setValue(model.required, forKey: "required")
        entity.setValue(model.params, forKey: "params")
        entity.setValue(model.order, forKey: "order")
    }
    
    public func list(forForm id: Int) -> [FormItem] {
        return self.list(request: self.list(forForm: id))
    }
    
    public func list(forForm id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "formId = %d", id)
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        return request
    }
    
}
