//
//  WebViewController.swift
//  QrCode
//
//  Created by sqluo on 2017/3/2.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController ,WKNavigationDelegate{

    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let str = self.url{
            
            if let path = URL(string: str){
                
                let webView = WKWebView(frame: self.view.bounds)
                webView.load(URLRequest(url: path))
                webView.navigationDelegate = self
                self.view.addSubview(webView)
            }
   
        }
   
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
