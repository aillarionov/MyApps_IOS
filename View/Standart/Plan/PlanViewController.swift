//
//  PlanViewController.swift
//  Informer
//
//  Created by Александр on 19.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController, UIScrollViewDelegate {
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerConstraint: NSLayoutConstraint!
    @IBOutlet weak var header: UISegmentedControl!
    @IBOutlet weak var image: UIImageView!
    
    var gi: Cancelable?
    
    let navigation: UINavigationController
    var plans: [String: String] = [:]
    var orgId : Int
    
    init(orgId: Int, params: String, navigation: UINavigationController) {
        self.orgId = orgId
        self.navigation = navigation
        super.init(nibName: "PlanViewController", bundle: nil)
        self.parseParams(params)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.orgId = aDecoder.value(forKey: "orgId") as! Int
        self.navigation = aDecoder.value(forKey: "navigation") as! UINavigationController
        super.init(coder: aDecoder)
        self.parseParams(aDecoder.value(forKey: "params") as! String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        self.scrollView.delegate = self
        
        self.generateHeader()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    private func updateMinZoomScaleForSize(_ size: CGSize) {
        image.sizeToImage()

        var minScale: CGFloat = 1
        if let img = self.image.image {
            let widthScale = (img.size.width > 0 ? size.width / img.size.width : 1)
            let heightScale = (img.size.height > 0 ? size.height / img.size.height : 1)
            minScale = min(widthScale, heightScale)
        }
        
        self.scrollView.minimumZoomScale = minScale
        self.scrollView.maximumZoomScale = 1
        self.scrollView.zoomScale = minScale
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.image
    }
    
    private func parseParams(_ params: String) {
        for item in params.split(separator: "|") {
            let kvp = item.split(separator: "=")
            if (kvp.count == 2) {
                plans[String(kvp[0])] = String(kvp[1])
            }
        }
    }
    
    private func generateHeader() {
        
        header.removeAllSegments()
        var i = 0
        
        if plans.count > 1 {
            NSLayoutConstraint.activate([headerConstraint])
            
            for plan in plans {
                header.insertSegment(withTitle: plan.key, at: i, animated: false)
                i += 1
            }
            
            header.isHidden = false

            header.selectedSegmentIndex = 0
            self.headerSelected(0)
        } else {
            header.isHidden = true
            NSLayoutConstraint.deactivate([headerConstraint])
            
            if let plan = plans.first {
                self.gi = ImageLoader.getTmpImage(imageView: self.image, url: plan.value , orgId: self.orgId)
            } else {
                self.gi = nil
                self.image.image = nil
            }
        }
    }
    
    @IBAction func headerSelected(_ sender: Any) {
        let index = self.header.selectedSegmentIndex
        if index >= 0 {
            let url: String = Array(self.plans)[index].value
            self.gi = ImageLoader.getTmpImage(imageView: self.image, url: url , orgId: self.orgId)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
