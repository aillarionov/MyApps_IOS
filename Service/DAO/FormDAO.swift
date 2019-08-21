//
//  FormDAO.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import CoreData

class FormDAO: OrgItemDAO<Form> {

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.entityName = "Form"
    }
    
    override internal func entityToModel(_ entity: NSManagedObject) -> Form {
        return Form(
            orgId: entity.value(forKey: "orgId") as! Int,
            id: entity.value(forKey: "id") as! Int,
            name: entity.value(forKey: "name") as! String
        )
    }
    
    override internal func applyModelToEntity(model: Form, entity: NSManagedObject) {
        entity.setValue(model.orgId, forKey: "orgId")
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.name, forKey: "name")
    }
    
}
