//
//  MenuItem.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

struct MenuItem: OrgItem {
    let orgId: Int
    let id: Int
    let name: String
    let icon: String
    let type: MenuItemType
    let params: [String: QuantumValue]
    let order: Int
}
