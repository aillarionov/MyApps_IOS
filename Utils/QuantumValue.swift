//
//  QuantumValue.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class QuantumValue: NSObject, NSCoding, Codable {
    
    private let value: Optional<String>
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        value = aDecoder.decodeObject() as? String
    }
    
    required init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()

        do {
            value = try String(container.decode(Bool.self))
            return
        } catch {
        }
        
        do {
            value = try String(container.decode(Int.self))
            return
        } catch {
        }
        
        do {
            value = try String(container.decode(Float.self))
            return
        } catch {
        }
        
        do {
            value = try container.decode(String.self)
            return
        } catch {
        }
        
        value = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
    func getBool() -> Optional<Bool> {
        return self.value != nil ? Bool(self.value!) : nil
    }
    
    func getInt() -> Optional<Int> {
        return self.value != nil ? Int(self.value!) : nil
    }
    
    func getFloat() -> Optional<Float> {
        return self.value != nil ? Float(self.value!) : nil
    }
    
    func getString() -> Optional<String> {
        return value
    }
}
