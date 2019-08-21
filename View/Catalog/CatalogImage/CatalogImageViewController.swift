//
//  CatalogImageViewController.swift
//  Inform
//
//  Created by Александр on 15.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class CatalogImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let navigation: UINavigationController
    let item: CatalogImage
    
     var gi: Cancelable?
    
    init(item: CatalogImage, navigation: UINavigationController) {
        self.item = item
        self.navigation = navigation
        super.init(nibName: "CatalogImageViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.item = aDecoder.value(forKey: "item") as! CatalogImage
        self.navigation = aDecoder.value(forKey: "navigation") as! UINavigationController
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        self.scrollView.delegate = self
        
        if let picture = self.item.pictures.first, let img = picture.images.first {
            self.gi = ImageLoader.getTmpImage(imageView: self.picture, image: img, orgId: self.item.orgId)
        } else {
            self.gi = nil
            self.picture.image = nil
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    private func updateMinZoomScaleForSize(_ size: CGSize) {
        picture.sizeToImage()
        
        var maxScale: CGFloat = 1
        if let img = self.picture.image {
            let widthScale = (img.size.width > 0 ? img.size.width / size.width : 1)
            let heightScale = (img.size.height > 0 ? img.size.height / size.height : 1)
            maxScale = max(widthScale, heightScale)
        }
        
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = maxScale
        self.scrollView.zoomScale = 1
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.picture
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
