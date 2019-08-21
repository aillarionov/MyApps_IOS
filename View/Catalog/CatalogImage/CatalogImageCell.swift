//
//  CatalogImageCell.swift
//  Inform
//
//  Created by Александр on 28.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class CatalogImageCell: UITableViewCell, CommonTableViewCell {
    typealias D = CatalogImage
    
    static let nib = UINib(nibName: "CatalogImageCell", bundle: nil)
    static let cellIdentifier = "CatalogImageCell"
    
    @IBOutlet weak var picture: UIImageView!
    
    var cancelable: Cancelable?
    var data: CatalogImage?
    
    static func getCellHeight() -> CGFloat {
        let imgAspect: CGFloat = 4 / 3
        
        let s = UIScreen.main.nativeScale
        let w = UIScreen.main.nativeBounds.width
        
        let imgH = (w - 10.0 * s) / imgAspect
        let h = imgH / s + 10.0/* outter */
        
        return h
    }
    
    func fillData(_ data: CatalogImage) {
        self.data = data

        self.picture.image = nil
        if let picture = data.pictures.first, let img = picture.images.first {
            self.cancelable = ImageLoader.getTmpImage(imageView: self.picture, image: img, orgId: data.orgId)
        } else {
            self.cancelable = nil
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
