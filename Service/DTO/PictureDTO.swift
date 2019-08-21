//
//  PictureDTO.swift
//  Inform
//
//  Created by Александр on 14.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class PictureDTO: Any {

    static func toModel(fromProxy: PictureProxy) -> Picture {
        
        let screenWidth = Int(UIScreen.main.nativeBounds.width)
        
        var maxWidth = 0

        for image in fromProxy.images {
            if (image.width > screenWidth && (image.width < maxWidth || 0 == maxWidth)) {
                maxWidth = image.width
            }
        }
        
        if (maxWidth == 0) {
            for image in fromProxy.images {
                if (image.width > maxWidth) {
                    maxWidth = image.width
                }
            }
        }
        
        var images: [Image] = []
        
        for image in fromProxy.images {
            if (image.width == maxWidth) {
                images.append(ImageDTO.toModel(fromProxy: image))
                break
            }
        }
        
        return Picture(images: images)
    }
    
}
