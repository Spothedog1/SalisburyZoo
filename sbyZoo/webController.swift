//
//  webController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 10/18/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import UIKit
import WebKit

class webController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    override func loadView() {
        super.loadView()    
    }
    
    override func viewDidLoad() {

        print("webController has loaded.")
        let url = URL(string: "http://salisburyzoo.org/maryland-salisbury-zoo-donate")
        let requestObj = URLRequest(url: url!);
        
        webView?.loadRequest(requestObj);

        super.viewDidLoad()
//        LoadingOverlay.shared.showOverlay(view: self.view)
//        LoadingOverlay.shared.hideOverlayView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
}
