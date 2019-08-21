//
//  CatalogNewsViewController.swift
//  Inform
//
//  Created by Александр on 26.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class CatalogNewsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UITextView!

    let navigation: UINavigationController
    let item: CatalogNews
    
    var gi: Cancelable?
    
    init(item: CatalogNews, navigation: UINavigationController) {
        self.item = item
        self.navigation = navigation
        super.init(nibName: "CatalogNewsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.compatibleIOS10()
        
        self.text.setHTMLFromString(self.item.text)
        
        if let picture = self.item.pictures.first, let img = picture.images.first {
            self.gi = ImageLoader.getTmpImage(imageView: self.image, image: img, orgId: self.item.orgId)
        } else {
            self.gi = nil
            self.image.image = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
