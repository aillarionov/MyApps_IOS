//
//  GMDate.swift
//  Inform
//
//  Created by Александр on 18.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class GMDate: Codable {
    
    private let date: Date?
    
    init(fromString: String) {
        let dateFormatter = ISO8601Formatter.iso8601Formatter(withFractional: false)
        self.date = dateFormatter.date(from: fromString)
    }
    
    func asDate() -> Date? {
        return self.date
    }
    
}
