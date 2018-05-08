//
//  OAuthViewController.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    let webView : UIWebView = UIWebView.init(frame: UIScreen.main.bounds)

    override func loadView() {
        super.loadView()
        view.addSubview(webView)
        webView.backgroundColor = UIColor.white
        title = "登陆新浪微博"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(text: "返回", image: "navigationButtonReturn", selectedImage: "navigationButtonReturnClick", normalTextColor: UIColor.black, selectedTextColor: UIColor.red, target: self, selector: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "填充", style: .plain, target: self, action: #selector(autoFull))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self;
        webView.scalesPageToFit = true
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(AppKey)&redirect_uri=\(RedirectURL)"
        guard let url = URL.init(string: urlString) else {
            return
        }
        
        webView.loadRequest(URLRequest.init(url: url))

    }

    @objc func autoFull() {
        let js = "document.getElementById('userId').value = '245383172@qq.com';" + " document.getElementById('passwd').value = 'chen13404018720'"
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

}


extension OAuthViewController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.dark)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        print(request.url?.absoluteString)
        if request.url?.absoluteString.hasPrefix(RedirectURL) == false {
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false{
            print("取消授权")
            return false
        }
        
        //取出code
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        //使用code请求accessToken
        CCYNetworkManager.shared.loadAccessToken(code: code) { (success) in
            if success == true {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CCYWeiBoShouldLoginSuccessNofication), object: nil)
                SVProgressHUD.dismiss()
                self.back()
            } else {
                SVProgressHUD.showInfo(withStatus: "授权失败")
            }
        }
        
        return true
    }
    
    

}
