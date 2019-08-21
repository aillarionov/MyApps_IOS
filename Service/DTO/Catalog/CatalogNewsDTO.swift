//
//  CatalogNewsDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class CatalogNewsDTO {
    
    static func toModel(fromProxy: CatalogNewsProxy, orgId: Int, catalogId: Int, order: Int) -> CatalogNews {
        var pictures: [Picture] = []
        
        for picture in fromProxy.pictures {
            pictures.append(PictureDTO.toModel(fromProxy: picture))
        }
        
        let id: String = String(fromProxy.id) + "|" + String(orgId) + "|" + String(catalogId)
        
        return CatalogNews (
            id: id,
            itemId: fromProxy.id,
            orgId: orgId,
            catalogId: catalogId,
            order: order,
            text: fromProxy.text,
            raw: fromProxy.raw,
            date: fromProxy.date,
            pictures: pictures,
            
            favorite: false
        )
    }
    
}
