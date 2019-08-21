//
//  FormItemData.swift
//  Inform
//
//  Created by Александр on 24.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class FormItemData {
    let formItem: FormItem
    var value: String?
    
    init(formItem: FormItem, value: String?) {
        self.formItem = formItem
        self.value = value
    }
}
