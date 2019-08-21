//
//  CatalogDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class CatalogDTO {

    static func toModel(fromProxy: CatalogProxy, orgId: Int) -> Catalog {
       
        return Catalog(
            orgId: orgId,
            id: fromProxy.id,
            lastChange: Date.min,
            type: fromProxy.type,
            presenterVisible: fromProxy.presenterVisible,
            visitorVisible: fromProxy.visitorVisible
        )
    }
    
}
