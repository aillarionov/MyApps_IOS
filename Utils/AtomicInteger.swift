//
//  AtomicInteger.swift
//  Inform
//
//  Created by Александр on 20.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

public final class AtomicInteger {
    
    private let lock = DispatchSemaphore(value: 1)
    private var _value: Int
    
    public init(value initialValue: Int = 0) {
        _value = initialValue
    }
    
    public var value: Int {
        get {
            lock.wait()
            defer { lock.signal() }
            return _value
        }
        set {
            lock.wait()
            defer { lock.signal() }
            _value = newValue
        }
    }
    
    public func decrementAndGet() -> Int {
        lock.wait()
        defer { lock.signal() }
        _value -= 1
        return _value
    }
    
    public func incrementAndGet() -> Int {
        lock.wait()
        defer { lock.signal() }
        _value += 1
        return _value
    }
}
