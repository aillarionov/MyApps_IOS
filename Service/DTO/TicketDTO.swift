//
//  TicketDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class TicketDTO {

    static func toModel(fromProxy:TicketProxy, orgId: Int) -> Ticket {

        return Ticket(
            id: orgId,
            type: fromProxy.type,
            source: fromProxy.source,
            text: fromProxy.text,
            button: fromProxy.button
        )
    }
    
}
