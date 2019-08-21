//
//  CatalogMemberDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class CatalogMemberDTO {
    
    static func toModel(fromProxy: CatalogMemberProxy, orgId: Int, catalogId: Int, order: Int) -> CatalogMember {
        var pictures: [Picture] = []
        
        for picture in fromProxy.pictures {
            pictures.append(PictureDTO.toModel(fromProxy: picture))
        }
        
        let id: String = String(fromProxy.id) + "|" + String(orgId) + "|" + String(catalogId)
        
        return CatalogMember(
            id: id,
            itemId: fromProxy.id,
            orgId: orgId,
            catalogId: catalogId,
            order: order,
            text: fromProxy.text,
            raw: fromProxy.raw,
            date: fromProxy.date,
            pictures: pictures,

            name: fromProxy.name,
            stand: fromProxy.stand,
            categories: fromProxy.categories,
            emails: fromProxy.emails,
            phones: fromProxy.phones,
            sites: fromProxy.sites,
            vks: fromProxy.vks,
            fbs: fromProxy.fbs,
            insts: fromProxy.insts,
            
            favorite: false
        )
    }
    
}
