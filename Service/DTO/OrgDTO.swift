//
//  OrgDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class OrgDTO {

    static func toModel(fromProxy: OrgProxy) -> Org {
        return Org(id: fromProxy.id, name: fromProxy.name, logo: fromProxy.logo, city: CityDTO.toModel(fromProxy: fromProxy.city))
    }
    
}
