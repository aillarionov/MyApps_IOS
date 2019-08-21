//
//  CatalogMemberProxy.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

struct CatalogMemberProxy: Codable {
    let id: Int
    let text: String
    let raw: String
    let date: Date
    let pictures: [PictureProxy]
    
    let name: Optional<String>
    let stand: Optional<String>
    
    let categories: [String]
    let emails: [String]
    let phones: [String]
    let sites: [String]
    let vks: [String]
    let fbs: [String]
    let insts: [String]
}
