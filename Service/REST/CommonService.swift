//
//  CommonService.swift
//  Informer
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class CommonService: Any {
    
    static func doGetRequest<T>(type: T.Type, url: URL, success: @escaping ((ServiceResponse<T>) -> Void),  failure: @escaping ((Error) -> Void))  -> Cancelable {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return self.doRequest(type: type, request: request, success: success, failure: failure)
    }
    
    static func doPostRequest<T, D>(type: T.Type, url: URL, data: D, success: @escaping ((ServiceResponse<T>) -> Void),  failure: @escaping ((Error) -> Void))  -> Cancelable where D: Encodable {
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return self.doRequest(type: type, request: request, success: success, failure: failure)
    }
    
    static func doPutRequest<T, D>(type: T.Type, url: URL, data: D, success: @escaping ((ServiceResponse<T>) -> Void),  failure: @escaping ((Error) -> Void))  -> Cancelable where D: Encodable {
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return self.doRequest(type: type, request: request, success: success, failure: failure)
    }
    
    private static func doRequest<T>(type: T.Type, request: URLRequest, success: @escaping ((ServiceResponse<T>) -> Void),  failure: @escaping ((Error) -> Void)) -> Cancelable {
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    failure(error)
                    return
                }
                
                guard let data = data else {
                    failure(ServiceDataError.NoData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    
                    if #available(iOS 10.0, *) {
                        decoder.dateDecodingStrategy = .iso8601
                    } else {
                        decoder.dateDecodingStrategy = .formatted(ISO8601Formatter())
                    }
                    
                    var lastModified: Date? = nil
                    
                    if let response = response as? HTTPURLResponse {
                        if let date = response.allHeaderFields["Last-Modified"] as? String {
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "en")
                            dateFormatter.dateFormat = "EEEE, dd LLL yyyy HH:mm:ss zzz"
                            lastModified = dateFormatter.date(from: date) as Date?
                        }
                    }
                    
                    if type == Empty.self {
                        success(ServiceResponse<T>(Empty() as! T, lastModified))

                    } else if type == GMDate.self {
                        success(ServiceResponse<T>(GMDate(fromString: data.toString()) as! T, lastModified))
                    
                    } else {
                        let result = try decoder.decode(type, from: data)
                        success(ServiceResponse<T>(result, lastModified))
                        
                    }
                    
                } catch let jsonError {
                    failure(jsonError)
                }
            }
            
        task.resume()
        
        return Cancelable {
            if task.state == .running || task.state == .suspended {
                task.cancel()
            }
        }
    }
   
}
