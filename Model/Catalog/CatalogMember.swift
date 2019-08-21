//
//  CatalogMember.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

struct CatalogMember: CatalogAbstractItem {
    let id: String
    
    let itemId: Int
    let orgId: Int
    let catalogId: Int
    
    let order: Int
    
    let text: String
    let raw: String
    let date: Date
    let pictures: [Picture]
    
    let name: Optional<String>
    let stand: Optional<String>
    
    let categories: [String]
    let emails: [String]
    let phones: [String]
    let sites: [String]
    let vks: [String]
    let fbs: [String]
    let insts: [String]
    
    let favorite: Bool
    
    var title: String {
        return name ?? text
    }
    
    var catalogType: CatalogType {
        return .Member
    }
    
}
