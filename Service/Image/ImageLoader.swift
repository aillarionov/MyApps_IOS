//
//  ImageLoader.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class ImageLoader {

    public static func getTmpImage(imageView: UIImageView, image: Image, orgId: Int?) -> Cancelable {
        return self.getImage(imageView: imageView, url: image.source, orgId: orgId, storeType: .Temporary)
    }
    
    public static func getTmpImage(imageView: UIImageView, url: String, orgId: Int?) -> Cancelable {
        return self.getImage(imageView: imageView, url: url, orgId: orgId, storeType: .Temporary)
    }
    
    public static func getPermImage(imageView: UIImageView, image: Image, orgId: Int?) -> Cancelable {
        return self.getImage(imageView: imageView, url: image.source, orgId: orgId, storeType: .Permanent)
    }

    public static func getPermImage(imageView: UIImageView, url: String, orgId: Int?) -> Cancelable {
        return self.getImage(imageView: imageView, url: url, orgId: orgId, storeType: .Permanent)
    }

    
    private static func getImage(imageView: UIImageView, url: String, orgId: Int?, storeType: ImageStoreType) -> Cancelable {
        let cancelable = Cancelable()
        
        if let url = URL(string: url) {
            
            let sc = ImageStoreService.getImageAsync(
                fromUrl: url,
                orgId: orgId,
                storeType: storeType,
                success: { image in
                    if cancelable.isCanceled() { return }
                    
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                },
                failure: { error in
                    if !(error is ErrorCanceled) {
                        print(error)
                    }
                }
            )
            
            cancelable.addCancel{ sc.cancel() }
        }
        
        return cancelable
    }
}
