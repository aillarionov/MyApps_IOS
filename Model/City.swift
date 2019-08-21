//
//  City
//  Inform
//
//  Created by Александр on 12.05.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class City: NSObject, NSCoding {
    let id: Int
    let name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! Int? ?? 0
        name = aDecoder.decodeObject(forKey: "name") as! String? ?? ""
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }
}
