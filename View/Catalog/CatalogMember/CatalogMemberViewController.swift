//
//  CatalogMemberViewController.swift
//  Inform
//
//  Created by Александр on 26.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class CatalogMemberViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UITextView!

    let navigation: UINavigationController
    let item: CatalogMember
    
    var gi: Cancelable?
    
    init(item: CatalogMember, navigation: UINavigationController) {
        self.item = item
        self.navigation = navigation
        super.init(nibName: "CatalogMemberViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.compatibleIOS10()
        
        self.fillText()
        
        if let picture = self.item.pictures.first, let img = picture.images.first {
            self.gi = ImageLoader.getTmpImage(imageView: self.image, image: img, orgId: self.item.orgId)
        } else {
            self.gi = nil
            self.image.image = nil
        }
    }
    
    func fillText() {
        var text: String = ""
        
        if let name = item.name {
            text += "<br>" + name + "<br>"
        }
        
        if let stand = item.stand {
            text += "<br>" + NSLocalizedString("Stand", comment: "") + ": " + stand
        }
        
        for category in item.categories {
            if !category.isEmpty {
                text += "<br>" + NSLocalizedString("Category", comment: "") + ": " + category
            }
        }
        
        for email in item.emails {
            text += "<br>" + NSLocalizedString("Email", comment: "") + ": " + self.makeLink(email, "mailto:")
        }
        
        for phone in item.phones {
            text += "<br>" + NSLocalizedString("Phone", comment: "") + ": " + self.makeLink(phone, "tel:")
        }
        
        for site in item.sites {
            text += "<br>" + NSLocalizedString("Site", comment: "") + ": " + self.makeLink(site, "")
        }
        
        for vk in item.vks {
            text += "<br>" + NSLocalizedString("VKontakte", comment: "") + ": " + self.makeLink(vk, "")
        }
        
        for fb in item.fbs {
            text += "<br>" + NSLocalizedString("Facebook", comment: "") + ": " + self.makeLink(fb, "")
        }
        
        for inst in item.insts {
            text += "<br>" + NSLocalizedString("Instagram", comment: "") + ": " + self.makeLink(inst, "")
        }
        
        text += "<br><br>" + item.text
        
        self.text.setHTMLFromString(text)
    }
    
    func makeLink(_ text: String, _ prefix: String) -> String {
        var link = prefix + text
        
        if (prefix.isEmpty) {
            if !link.starts(with: "http") && !link.contains("://") {
                link =  "http://" + link
            }
        }
        
        return "<a href=\"" + link + "\">" + text + "</a>"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
