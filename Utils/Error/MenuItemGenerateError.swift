//
//  MenuItemGenerateError.swift
//  Informer
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class MenuItemGenerateError: Error {
    let message: String
    let menuItem: MenuItem?
    
    init(_ message: String, _ menuItem: MenuItem?) {
        self.message = message
        self.menuItem = menuItem
    }
}
