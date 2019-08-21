//
//  FormProxy.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

struct FormProxy: Codable {
    let id: Int
    let name: String
    let items: [FormItemProxy]
}
