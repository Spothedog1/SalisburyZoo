//
//  webController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 10/18/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class webController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    override func loadView() {
        super.loadView()    
    }
    
    override func viewDidLoad() {
        print("webController has loaded.")
        let url = URL(string: "http://mobile.salisburyzoo.org")
        let requestObj = URLRequest(url: url!);
        
        webView?.loadRequest(requestObj);
        super.viewDidLoad()
    }
    
    

}
