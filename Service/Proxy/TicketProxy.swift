//
//  TicketProxy.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

struct TicketProxy: Codable {
    let type: TicketType
    let source: String?
    let text: String?
    let button: String?
}
