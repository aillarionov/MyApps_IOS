//
//  CatalogNewsProxy.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

struct CatalogNewsProxy: Codable {
    let id: Int
    let text: String
    let raw: String
    let date: Date
    let pictures: [PictureProxy]
}
