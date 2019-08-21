//
//  MenuItemViewCell.swift
//  Inform
//
//  Created by Александр on 26.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class MenuItemViewCell: UITableViewCell, CommonTableViewCell {
    typealias D = UIViewController
    
    static let nib = UINib(nibName: "MenuItemViewCell", bundle: nil)
    static let cellIdentifier = "MenuItemViewCell"
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    static func getCellHeight() -> CGFloat {
        return 44
    }
    
    func fillData(_ data: UIViewController) {
        self.label.text = data.tabBarItem.title
        self.picture.image = data.tabBarItem.image
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
