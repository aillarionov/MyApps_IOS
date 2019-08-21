//
//  CatalogItem.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

struct CatalogItem: CatalogAbstractItem {
    let id: String
    
    let itemId: Int
    let orgId: Int
    let catalogId: Int
    
    let order: Int
    
    let text: String
    let raw: String
    let date: Date
    let pictures: [Picture]
    
    let favorite: Bool
    
    var title: String {
        return text
    }
    
    var catalogType: CatalogType {
        return .Item
    }

}
