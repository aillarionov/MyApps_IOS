//
//  CommonTableViewCell.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

protocol CommonTableViewCell {
    associatedtype D
    
    static var nib: UINib { get }
    static var cellIdentifier: String { get }
    
    static func getCellHeight() -> CGFloat
        
    func fillData(_ data: D)
}
