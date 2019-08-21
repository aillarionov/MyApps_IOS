//
//  CatalogItemCell.swift
//  Inform
//
//  Created by Александр on 28.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class CatalogItemCell: UITableViewCell, CommonTableViewCell {
    typealias D = CatalogItem
    
    static let nib = UINib(nibName: "CatalogItemCell", bundle: nil)
    static let cellIdentifier = "CatalogItemCell"
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var cancelable: Cancelable?
    var data: CatalogItem?
    
    static func getCellHeight() -> CGFloat {
        let imgAspect: CGFloat = 4 / 3
        
        let s = UIScreen.main.nativeScale
        let w = UIScreen.main.nativeBounds.width
        
        let imgH = (w - 10.0 * s) / imgAspect
        let h = imgH / s + 10.0/* outter */ + 4.0/* inner */ + 60.0/* label */
        
        return h
    }
    
    func fillData(_ data: CatalogItem) {
        self.data = data
        
        self.label.setHTMLFromString(data.title)

        self.button.setImage(data.favorite ? #imageLiteral(resourceName: "liked") : #imageLiteral(resourceName: "like"), for: .normal)

        self.picture.image = nil
        if let picture = data.pictures.first, let img = picture.images.first {
            self.cancelable = ImageLoader.getTmpImage(imageView: self.picture, image: img, orgId: data.orgId)
        } else {
            self.cancelable = nil
        }
    }

    @IBAction func buttonTouchUpInside(_ sender: Any) {
        guard let data = self.data else { return }
        
        let worker = DataWorker()
        let context = worker.begin()
        
        let favoriteDAO = FavoriteDAO(context: context)
        
        if data.favorite {
            favoriteDAO.delete(by: data)
        } else {
            favoriteDAO.create(from: data)
        }
        
        CatalogItemDAO(context: context).upVer(data)
        
        do {
            try worker.commmit()
        } catch let error {
            print(error)
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
