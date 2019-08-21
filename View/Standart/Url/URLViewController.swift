//
//  URLViewController.swift
//  Inform
//
//  Created by Александр on 20.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import WebKit

class URLViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    let navigation: UINavigationController
    let url: String
    
    init(url: String, navigation: UINavigationController) {
        self.url = url
        self.navigation = navigation
        super.init(nibName: "URLViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.value(forKey: "url") as! String
        self.navigation = aDecoder.value(forKey: "navigation") as! UINavigationController
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.backgroundColor = UIColor.cyan
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        let myURL = URL(string: self.url)
        let myRequest = URLRequest(url: myURL!)
        
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
