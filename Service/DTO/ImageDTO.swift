//
//  ImageDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

class ImageDTO: Any {

    static func toModel(fromProxy: ImageProxy) -> Image {
        return Image(width: fromProxy.width, height: fromProxy.height, source: fromProxy.source)
    }
    
}
