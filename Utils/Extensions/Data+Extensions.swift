//
//  Data+Extensions.swift
//  Inform
//
//  Created by Александр on 18.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

extension Data
{
    func toString() -> String
    {
        return String(data: self, encoding: .utf8)!
    }
}

