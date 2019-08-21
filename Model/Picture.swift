//
//  Picture.swift
//  Informer
//
//  Created by Александр on 13.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class Picture: NSObject, NSCoding {
    
    let images: [Image]
   
    required init?(coder aDecoder: NSCoder) {
        images = aDecoder.decodeObject(forKey: "images") as? [Image] ?? []
        super.init()
    }
    
    init(images: [Image]) {
        self.images = images
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(images, forKey: "images")
    }
}
