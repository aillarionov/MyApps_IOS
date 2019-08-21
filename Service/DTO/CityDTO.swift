//
//  CityDTO.swift
//  Inform
//
//  Created by Александр on 12.05.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class CityDTO {

    static func toModel(fromProxy:CityProxy) -> City {

        return City(
            id: fromProxy.id,
            name: fromProxy.name
        )
    }
    
}
