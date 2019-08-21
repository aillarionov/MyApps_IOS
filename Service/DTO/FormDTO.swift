//
//  FormDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class FormDTO {

    static func toModel(fromProxy: FormProxy, orgId: Int) -> Form {

        return Form(
            orgId: orgId,
            id: fromProxy.id,
            name: fromProxy.name
        )
    }
    
}
