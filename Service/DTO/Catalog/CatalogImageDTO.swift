//
//  CatalogImageDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class CatalogImageDTO {
    
    static func toModel(fromProxy: CatalogImageProxy, orgId: Int, catalogId: Int, order: Int) -> CatalogImage {
        var pictures: [Picture] = []
        
        for picture in fromProxy.pictures {
            pictures.append(PictureDTO.toModel(fromProxy: picture))
        }
        
        let id: String = String(fromProxy.id) + "|" + String(orgId) + "|" + String(catalogId)
        
        return CatalogImage (
            id: id,
            itemId: fromProxy.id,
            orgId: orgId,
            catalogId: catalogId,
            order: order,
            date: fromProxy.date,
            pictures: pictures,
            
            favorite: false
        )
    }
    
}
