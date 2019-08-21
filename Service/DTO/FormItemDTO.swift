//
//  FormItemDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class FormItemDTO {

    static func toModel(fromProxy: FormItemProxy, orgId: Int, formId: Int) -> FormItem {
        
        return FormItem(
            orgId: orgId,
            formId: formId,
            id: fromProxy.id,
            type: fromProxy.type,
            name: fromProxy.name,
            title: fromProxy.title,
            required: fromProxy.required,
            params: fromProxy.params,
            order: fromProxy.order
        )
    }
    
}
