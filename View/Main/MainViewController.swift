//
//  MainViewController.swift
//  Inform
//
//  Created by Александр on 18.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    private let orgId: Int
    private var gm: Cancelable?
    
    init(orgId: Int) {
        self.orgId = orgId
        super.init(nibName: "MainViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        let notificationProcessor = NotificationProcessor(rootView: self)
        
        NotificationQue.shared.subscribe { notification in
            notificationProcessor.processMessage(notification)
        }
        
        self.gm = MenuUtils().generateMenu(
            self.orgId,
            success: { buttons in
                DispatchQueue.main.async {
                    self.viewControllers = buttons
                }
            },
            failure: { print($0) }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
