//
//  AbstractItemCell.swift
//  Inform
//
//  Created by Александр on 28.03.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class AbstractItemCell: UITableViewCell, CommonTableViewCell {
    typealias D = CatalogAbstractItem
    
    static let nib = UINib(nibName: "AbstractItemCell", bundle: nil)
    static let cellIdentifier = "AbstractItemCell"
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var cancelable: Cancelable?
    var data: CatalogAbstractItem?
    
    static func getCellHeight() -> CGFloat {
        let imgAspect: CGFloat = 4 / 3
        
        let s = UIScreen.main.nativeScale
        let w = UIScreen.main.nativeBounds.width
        
        let imgH = (w - 10.0 * s) / imgAspect
        let h = imgH / s + 10.0/* outter */ + 4.0/* inner */ + 60.0/* label */
        
        return h
    }
    
    func fillData(_ data: CatalogAbstractItem) {
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
    
    @IBAction func buttonTouchUp(_ sender: Any) {
        guard let data = self.data else { return }
        
        let worker = DataWorker()
        let context = worker.begin()
        
        let favoriteDAO = FavoriteDAO(context: context)
        
        if data.favorite {
            favoriteDAO.delete(by: data)
        } else {
            favoriteDAO.create(from: data)
        }
        
        switch data.catalogType {
        case .Item:
            CatalogItemDAO(context: context).upVer(data as! CatalogItem)
        case .Member:
            CatalogMemberDAO(context: context).upVer(data as! CatalogMember)
        case .Image:
            CatalogImageDAO(context: context).upVer(data as! CatalogImage)
        case .News:
            CatalogNewsDAO(context: context).upVer(data as! CatalogNews)
        }
        
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
