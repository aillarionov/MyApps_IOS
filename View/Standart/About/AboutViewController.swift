//
//  AboutViewController.swift
//  Inform
//
//  Created by Александр on 26.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UITextView!

    let navigation: UINavigationController
    let catalogId: Int
    
    var gc: Cancelable?
    var gi: Cancelable?
    
    init(catalogId: Int, navigation: UINavigationController) {
        self.catalogId = catalogId
        self.navigation = navigation
        super.init(nibName: "AboutViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.compatibleIOS10()
        
        self.gc = LocalDataStore.getCatalogNews(
            catalogId: self.catalogId,
            context: Globals.getViewContext(),
            success: { news in
                if let news = news.first {
                    DispatchQueue.main.async {
                        self.text.setHTMLFromString(news.text)
                        
                        if let picture = news.pictures.first, let img = picture.images.first {
                            self.gi = ImageLoader.getTmpImage(imageView: self.image, image: img, orgId: news.orgId)
                        } else {
                            self.gi = nil
                            self.image.image = nil
                        }
                    }
                }
            },
            failure: { print($0) }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
