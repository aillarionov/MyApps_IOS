//
//  OrgProxy.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

struct OrgProxy: Codable {
    let id: Int
    let name: String
    let logo: String
    let catalogs: [CatalogProxy]
    let menuItems: [MenuItemProxy]
    let forms: [FormProxy]
    let ticket: TicketProxy?
    let city: CityProxy
}

