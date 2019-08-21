//
//  ServiceResponse.swift
//  Inform
//
//  Created by Александр on 18.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

struct ServiceResponse<T> where T: Decodable {
    var lastChange: Date?
    var data: T
    
    init(_ data: T, _ lastChange: Date?) {
        self.data = data
        self.lastChange = lastChange
    }
    
    init(_ data: T) {
        self.data = data
    }
    
}
