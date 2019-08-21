//
//  FormDataProxy.swift
//  Inform
//
//  Created by Александр on 24.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

struct FormDataProxy: Codable {
    let formId: Int
    let data: [FormDataItemProxy]
}

