//
//  FormItem.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

struct FormItem: OrgItem {
    let orgId: Int
    let formId: Int
    let id: Int
    let type: FormItemType
    let name: String
    let title: String
    let required: Bool
    let params: [String: QuantumValue]
    let order: Int
}
