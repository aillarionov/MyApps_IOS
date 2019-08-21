//
//  String+Extensions.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

extension String {
    var utfData: Data? {
        return self.data(using: .utf8)
    }
    
    var MD5: String {
        get{
            let messageData = self.utfData!
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            
            _ = digestData.withUnsafeMutableBytes {digestBytes in
                messageData.withUnsafeBytes {messageBytes in
                    CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
                }
            }
            
            return digestData.map { String(format: "%02hhx", $0) }.joined()
        }
    }
}

