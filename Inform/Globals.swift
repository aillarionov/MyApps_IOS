//
//  Globals.swift
//  Inform
//
//  Created by Александр on 18.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

class Globals: Any {
    static let shared = Globals()
    static let restEndpoint: String = ""
    
    public var version: String
    
    private init() {
        if let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.version = v
        } else {
            self.version = "<unknown>"
        }
    }
    
    public static func getMainContext() -> NSManagedObjectContext {
        var context: NSManagedObjectContext?
        
        if Thread.isMainThread {
            context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        } else {
            DispatchQueue.main.sync {
                context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            }
        }
        
        return context!
    }
    
    public static func getViewContext() -> NSManagedObjectContext {
        return self.getMainContext()
    }
}
