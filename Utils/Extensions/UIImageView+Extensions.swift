//
//  UIImageView+Extensions.swift
//  Informer
//
//  Created by Александр on 20.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

extension UIImageView {

    func sizeToImage() {
        
        if let image = self.image {
            self.frame  = CGRect (x: 0, y: 0, width: image.size.width, height: image.size.height);
        }
        
        return;
    }
}
