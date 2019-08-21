//
//  CatalogService.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class CatalogService: CommonService {

    static func get<T>(id: Int, success: @escaping ((ServiceResponse<[T]>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let url = URL(string: Globals.restEndpoint + "catalog/" + String(id))!

        return doGetRequest(type: [T].self, url: url, success: success, failure: failure)
    }
    
    static func getLastModified(id: Int, success: @escaping ((ServiceResponse<GMDate>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let url = URL(string: Globals.restEndpoint + "cache/catalog/" + String(id))!
        
        return doGetRequest(type: GMDate.self, url: url, success: success, failure: failure)
    }
}
