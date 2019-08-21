//
//  SettingsProxy.swift
//  Inform
//
//  Created by Александр on 24.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

struct SettingsProxy: Codable {
        let orgId: Int
        var isVisitor: Bool
        var isPresenter: Bool
        var receiveNotifications: Bool
}

