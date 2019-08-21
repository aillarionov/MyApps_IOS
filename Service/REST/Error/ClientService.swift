//
//  ClientService.swift
//  Inform
//
//  Created by Александр on 01.04.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class ClientService: CommonService {

    static func sendForm(formData: FormDataProxy, success: @escaping ((ServiceResponse<Empty>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let url = URL(string: Globals.restEndpoint + "client/form")!

        return doPostRequest(type: Empty.self, url: url, data: formData, success: success, failure: failure)
    }
    
    static func sendClientData(clientData: ClientDataProxy, success: @escaping ((ServiceResponse<Empty>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let url = URL(string: Globals.restEndpoint + "client/data")!

        return doPutRequest(type: Empty.self, url: url, data: clientData, success: success, failure: failure)
    }
    
    static func sendCallback(callback: CallbackProxy, success: @escaping ((ServiceResponse<Empty>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        let url = URL(string: Globals.restEndpoint + "client/callback")!
        
        return doPostRequest(type: Empty.self, url: url, data: callback, success: success, failure: failure)
    }
    
    
}
