//
//  NotificationQue.swift
//  Inform
//
//  Created by Александр on 26.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

final class NotificationQue {
    static let shared = NotificationQue()

    private var subscribe: ((NotificationPayload) -> Void)?
    private var notification: NotificationPayload?

    private init() { }
    
    public func subscribe(_ f: @escaping (NotificationPayload) -> Void) {
        self.subscribe = f
        if self.notification != nil {
            f(self.notification!)
        }
    }
    
    public func notify(_ n: NotificationPayload) {
        self.notification = n
    
        if self.subscribe != nil {
            self.subscribe!(n)
        }
    }
    
    
    
}
