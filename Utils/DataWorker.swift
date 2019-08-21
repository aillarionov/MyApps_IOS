//
//  DataWorker.swift
//  Inform
//
//  Created by Александр on 29.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class DataWorker {

    private static let work = AtomicInteger(value: 0)
    private static let workGroup = DispatchGroup()
    
    private let context: NSManagedObjectContext
    private var started = false
    
    init() {
        self.context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        if Thread.isMainThread {
            self.context.parent = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        } else {
            DispatchQueue.main.sync {
                self.context.parent = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            }
        }
    }

    public func begin() -> NSManagedObjectContext {
        DataWorker.workGroup.wait()
        _ = DataWorker.work.incrementAndGet()
        self.started = true
        return self.context
    }
    
    public func commmit() throws {
        if !self.started {
            throw WorkerError.WorkNotStarted
        }
        self.started = false
        
        do {
            try self.context.save()
        } catch let error {
            do {
                try self.finish()
            } catch let error2 {
                print(error2)
            }
            throw error
        }

        try self.finish()
    }
    
    public func rollback() throws {
        if !self.started {
            throw WorkerError.WorkNotStarted
        }
        self.started = false
        
        self.context.rollback()
        
        try self.finish()
    }
    
    private func finish() throws  {
        let w = DataWorker.work.decrementAndGet()
        
        if w == 0 {
            do {
                DataWorker.workGroup.enter()
                try self.context.parent?.save()
                DataWorker.workGroup.leave()
            } catch let error {
                DataWorker.workGroup.leave()
                throw error
            }
        }
    }
    
}
