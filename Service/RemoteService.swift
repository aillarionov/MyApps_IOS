//
//  RemoteService.swift
//  Inform
//
//  Created by Александр on 18.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class RemoteService: Any {
    
    static func getCititesList(success: @escaping ((ServiceResponse<[CityProxy]>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        return OrgService.getCities(success: success, failure: failure)
    }
    
    static func getOrgList(cityId: Int, success: @escaping ((ServiceResponse<[SimpleOrgProxy]>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        return OrgService.getList(cityId: cityId, success: success, failure: failure)
    }
    
    static func getOrg(orgId: Int, success: @escaping ((ServiceResponse<OrgProxy>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        return OrgService.get(id: orgId, success: success, failure: failure)
    }
    
    static func getOrg(code: String, success: @escaping ((ServiceResponse<OrgProxy>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        return OrgService.get(code: code, success: success, failure: failure)
    }
    
    static func getCatalogItems<T>(type: T.Type, catalogId: Int, success: @escaping ((ServiceResponse<[T]>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        return CatalogService.get(id: catalogId, success: success, failure: failure)
    }
    
    static func getCatalogLastModified(catalogId: Int, success: @escaping ((ServiceResponse<GMDate>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        return CatalogService.getLastModified(id: catalogId, success: success, failure: failure)
    }
    
    static func sendForm(_ data: FormDataProxy, success: @escaping ((ServiceResponse<Empty>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        return ClientService.sendForm(formData: data, success: success, failure: failure)
    }
    
    static func sendClientData(_ data: ClientDataProxy, success: @escaping ((ServiceResponse<Empty>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        return ClientService.sendClientData(clientData: data, success: success, failure: failure)
    }
    
    static func sendCallback(_ data: CallbackProxy, success: @escaping ((ServiceResponse<Empty>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        
        return ClientService.sendCallback(callback: data, success: success, failure: failure)
    }
}
