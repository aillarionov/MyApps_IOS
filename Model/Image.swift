//
//  Image.swift
//  Inform
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class Image: NSObject, NSCoding {
   
    let width: Int
    let height: Int
    let source: String
    
    required init?(coder aDecoder: NSCoder) {
        width = aDecoder.decodeObject(forKey: "width") as? Int ?? 0
        height = aDecoder.decodeObject(forKey: "height") as? Int ?? 0
        source = aDecoder.decodeObject(forKey: "source") as? String ?? ""
        
        super.init()
    }
    
    init(width: Int, height: Int, source: String) {
        self.width = width
        self.height = height
        self.source = source
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(width, forKey: "width")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(source, forKey: "source")
    }
}
