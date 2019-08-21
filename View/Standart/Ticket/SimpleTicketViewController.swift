//
//  SimpleTicketView.swift
//  Informer
//
//  Created by Александр on 20.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class SimpleTicketViewController: UIViewController {

    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var noHeaderConstraint: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!

    let navigation: UINavigationController
    var orgId: Int
    
    var ticket: Ticket?
    
    var gi: Cancelable?
    
    init(orgId: Int, navigation: UINavigationController) {
        self.orgId = orgId
        self.navigation = navigation
        super.init(nibName: "SimpleTicketViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.orgId = aDecoder.value(forKey: "orgId") as! Int
        self.navigation = aDecoder.value(forKey: "navigation") as! UINavigationController
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        let context = Globals.getViewContext()
        let dao = TicketDAO(context: context)
        self.ticket = dao.get(orgId)
        loadTicket()
    }

    private func loadTicket() {
        guard let ticket = self.ticket else { return }
        
        // Открыть билет сразу, если уже получен
        if let source = ticket.source, let url = URL(string: source) {
            if ImageStoreService.isImageLoaded(fromUrl: url, orgId: ticket.id, storeType: .Permanent) {
                self.openImage(source)
                return
            }
        }
        
        self.image.isHidden = true
        
        // Показать форму получения билета
        if let text = ticket.text {
            self.text.setHTMLFromString(text)
        } else {
            self.text.isHidden = true
            NSLayoutConstraint.deactivate([self.noHeaderConstraint])
        }
        
        if let text = ticket.button {
            self.button.setTitle(text, for: .normal)
        } else {
            self.button.isHidden = true
        }
    }
    
    private func openImage(_ source: String) {
        self.image.isHidden = false
        self.text.isHidden = true
        self.button.isHidden = true
        
        self.gi = ImageLoader.getPermImage(imageView: self.image, url: source , orgId: self.orgId)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if let ticket = self.ticket, let source = ticket.source {
            self.openImage(source)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}
