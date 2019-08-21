//
//  CatalogImageProxy.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

struct CatalogImageProxy: Codable {
    let id: Int
    let date: Date
    let pictures: [PictureProxy]
}
