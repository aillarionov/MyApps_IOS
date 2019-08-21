//
//  OrgListCell.swift
//  Inform
//
//  Created by Александр on 19.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class OrgListCell: UITableViewCell, CommonTableViewCell {
    typealias D = SimpleOrgProxy

    static let nib = UINib(nibName: "OrgListCell", bundle: nil)
    static let cellIdentifier = "OrgListCell"
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var cancelable: Cancelable?
    
    static func getCellHeight() -> CGFloat {
        return 70
    }
    
    func fillData(_ data: SimpleOrgProxy) {
        self.label.text = data.name
        self.cityLabel.text = data.city.name
        self.cancelable = ImageLoader.getTmpImage(imageView: self.picture, url: data.logo, orgId: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
