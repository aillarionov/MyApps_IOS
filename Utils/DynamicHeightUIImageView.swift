//
//  UIImageView
//  Informer
//
//  Created by Александр on 15.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation
import UIKit

class  DynamicHeightUIImageView: UIImageView {
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        updateViewHeightByImageRatio()
    }
    
    override var image: UIImage? {
        get {
            return super.image
        }
        
        set {
            super.image = newValue
            updateViewHeightByImageRatio()
        }
    }
    
    func updateViewHeightByImageRatio() {
        guard let img = self.image else { return }
        
        let ratio = img.size.width != 0 ? img.size.height / img.size.width : 1
        let height = self.bounds.width * ratio
        
        for constraint in self.constraints {
            if (constraint.firstAttribute == .height && constraint.secondAttribute == .notAnAttribute) {
                NSLayoutConstraint.deactivate([constraint])
                break;
            }
        }

        let newConstraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: height)

        newConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([newConstraint])
        
    }
    
}
