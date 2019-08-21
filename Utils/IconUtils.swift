//
//  IconUtils.swift
//  Informer
//
//  Created by Александр on 22.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class IconUtils: Any {
    
    static func getIconByName(_ name: String) -> UIImage {
        switch name {
            
        case "address": return #imageLiteral(resourceName: "address")
        case "discounts": return #imageLiteral(resourceName: "discounts")
        case "entry": return #imageLiteral(resourceName: "entry")
        case "exhibition": return #imageLiteral(resourceName: "exhibition")
        case "exhibitions": return #imageLiteral(resourceName: "exhibitions")
        case "exhibitor": return #imageLiteral(resourceName: "exhibitor")
        case "favorites": return #imageLiteral(resourceName: "favorites")
        case "like": return #imageLiteral(resourceName: "like")
        case "liked": return #imageLiteral(resourceName: "liked")
        case "news": return #imageLiteral(resourceName: "news")
        case "partners": return #imageLiteral(resourceName: "partners")
        case "photogallery": return #imageLiteral(resourceName: "photogallery")
        case "plan": return #imageLiteral(resourceName: "plan")
        case "question": return #imageLiteral(resourceName: "question")
        case "search": return #imageLiteral(resourceName: "search")
        case "setting": return #imageLiteral(resourceName: "setting")
        case "tickets": return #imageLiteral(resourceName: "tickets")
        
        default:
            return #imageLiteral(resourceName: "noimage")
        }
    }
    
}
