//
//  ClientDataProxy.swift
//  Inform
//
//  Created by Александр on 24.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

struct ClientDataProxy: Codable {
    let ostype: String = "ios"
    let token: String?
    let ad: String?
    let orgConfigs: [SettingsProxy]
}
