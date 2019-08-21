//
//  Cancelable.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class Cancelable {
    
    private var canceled: Bool = false
    private var cancelFuncs: [(() -> Void)] = []
    
    init() {
        
    }
    
    init(cancelFunc: @escaping (() -> Void)) {
        self.cancelFuncs.append(cancelFunc)
    }
    
    deinit {
        self.cancel()
    }
    
    public func addCancel(cancelFunc: @escaping (() -> Void)) {
        self.cancelFuncs.append(cancelFunc)
    }
    
    public func cancel() {
        if self.canceled {
            return
        }
        
        for cancelFunc in self.cancelFuncs {
            cancelFunc()
        }
        
        self.canceled = true
    }
    
    public func isCanceled() -> Bool {
        return self.canceled
    }
    
    
}
