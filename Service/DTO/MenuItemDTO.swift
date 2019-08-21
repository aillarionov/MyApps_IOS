//
//  MenuItemDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class MenuItemDTO {

    static func toModel(fromProxy: MenuItemProxy, orgId: Int) -> MenuItem {
        
        return MenuItem(
            orgId: orgId,
            id: fromProxy.id,
            name: fromProxy.name,
            icon: fromProxy.icon ?? "",
            type: fromProxy.type,
            params: fromProxy.params,
            order: fromProxy.order
        )
    }
    
}
