//
//  WebViewController.swift
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WebViewController: BaseViewController {
    
    let webView : WKWebView = WKWebView.init(frame: UIScreen.main.bounds)
    var link : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        
        webView.navigationDelegate = self
        view.insertSubview(webView, belowSubview: navigationBar)
        
        guard let link = link,
            let url = URL.init(string: link)
        else {
            return
        }
        webView.load(URLRequest.init(url: url))
        
        
    }
    
    override func setupTableView() {
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .automatic
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(navigationBar.frame.size.height - self.view.safeAreaInsets.top, 0, 0, 0)
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(navigationBar.frame.size.height, 0, 0, 0)
        }
        self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset
    }
}

extension WebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        self.title = webView.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
}
