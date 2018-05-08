//
//  BaseViewController.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import MJRefresh

class BaseViewController: UIViewController {
    
    lazy var navigationBar : CustomNavigationBar = CustomNavigationBar.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.screen_width(), height: 64))
    
    var visitorInfo : [String : AnyObject]?
    
    var navItem : UINavigationItem = UINavigationItem()
    
    var tableView : UITableView?
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccss), name: NSNotification.Name(rawValue: CCYWeiBoShouldLoginSuccessNofication), object: nil)
        
    }
    
    @objc func loginSuccss() {
        navItem.leftBarButtonItem = nil;
        navItem.rightBarButtonItem = nil;
        
        
        NotificationCenter.default.removeObserver(self)
        
        //调用生命周期
        view = nil
    }
    
    @objc func regisClick() {
//        let vc = ProfileViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func loginClick() {
        let vc = OAuthViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupTableView() {
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView?.estimatedRowHeight = 0
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.estimatedSectionHeaderHeight = 0
        
        self.view.insertSubview(tableView!, belowSubview: navigationBar)
        tableView?.dataSource = self;
        tableView?.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .automatic
            self.tableView?.contentInset = UIEdgeInsetsMake(navigationBar.frame.size.height - self.view.safeAreaInsets.top, 0, 0, 0)
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
            tableView?.contentInset = UIEdgeInsetsMake(navigationBar.frame.size.height, 0, 44, 0)
        }
        self.tableView?.scrollIndicatorInsets = (self.tableView?.contentInset)!
    }
}

extension BaseViewController {
    
    func setupUI() {
        self.setupNavigationBar()
        
        //看是否登录
        CCYNetworkManager.shared.isLogin ? setupTableView() : setupVistorView()

    }
    
    private func setupNavigationBar() {
        self.view.addSubview(navigationBar);
        navigationBar.items = [navItem]
        navigationBar.setBackgroundImage(UIImage.init(named: "navigationbarBackgroundWhite"), for: .default)
        navigationBar.tintColor = UIColor.orange
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
    }
    
    ///只有未登录才显示访客视图
    private func setupVistorView() {
        let vistorView = VistorView.init(frame: self.view.bounds)
        vistorView.vistorInfo = self.visitorInfo
        vistorView.registerButton.addTarget(self, action:#selector(regisClick), for: .touchUpInside)
        vistorView.loginButton.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        self.view.insertSubview(vistorView, belowSubview: self.navigationBar)
        
        //导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action: #selector(regisClick))
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "登陆", style: .plain, target: self, action: #selector(loginClick))
    }
    
}

extension BaseViewController : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
