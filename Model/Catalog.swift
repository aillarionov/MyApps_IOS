//
//  Catalog.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

struct Catalog: OrgItem {
    let orgId: Int
    let id: Int

    var lastChange: Date
    
    let type: CatalogType
    let presenterVisible: Bool
    let visitorVisible: Bool
}
