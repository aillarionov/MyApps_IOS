//
//  SettingsDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class SettingsDTO {

    static func topProxy(fromModel: Settings) -> SettingsProxy {
        return SettingsProxy(
            orgId: fromModel.id,
            isVisitor: fromModel.isVisitor,
            isPresenter: fromModel.isPresenter,
            receiveNotifications: fromModel.receiveNotifications
        )
    }
    
}
