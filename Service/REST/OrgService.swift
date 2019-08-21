//
//  OrgService.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class OrgService: CommonService {

    static func getCities(success: @escaping ((ServiceResponse<[CityProxy]>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let url = URL(string: Globals.restEndpoint + "cities")!
        
        return doGetRequest(type: [CityProxy].self, url: url, success: success, failure: failure)
    }
    
    static func getList(cityId: Int, success: @escaping ((ServiceResponse<[SimpleOrgProxy]>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let url = URL(string: Globals.restEndpoint + "orgs/" + String(cityId))!
        
        return doGetRequest(type: [SimpleOrgProxy].self, url: url, success: success, failure: failure)
    }
    
    
    static func get(id: Int, success: @escaping ((ServiceResponse<OrgProxy>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let url = URL(string: Globals.restEndpoint + "org/" + String(id))!

        return doGetRequest(type: OrgProxy.self, url: url, success: success, failure: failure)
    }

    static func get(code: String, success: @escaping ((ServiceResponse<OrgProxy>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let url = URL(string: Globals.restEndpoint + "org/code/" + code)!
        
        return doGetRequest(type: OrgProxy.self, url: url, success: success, failure: failure)
    }
}
