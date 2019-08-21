//
//  CatalogProxy.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

struct CatalogProxy: Codable {
    let id: Int
    let type: CatalogType
    let visitorVisible: Bool
    let presenterVisible: Bool
}
