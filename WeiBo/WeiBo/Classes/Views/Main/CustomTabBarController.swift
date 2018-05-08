//
//  CustomTabBarController.swift
//  WeiBo
//
//  Created by godyu on xxxxb2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupChildController()
        self.setupComposeButton()

        setupNewFeature()
        
        //注册需要登录的通知
        NotificationCenter.default.addObserver(self, selector: #selector(login), name: Notification.Name(rawValue: CCYWeiBoShouldLoginNotfication), object: nil)
        
    }
    
    @objc func login() {
        let vc = OAuthViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func composeClick() {
        
        let composeView = WBComposeView.composeView()
        composeView.show { [weak self] (className) in
            guard let className = className,
                let cls = NSClassFromString("WeiBo." + className) as? WBComposeViewController.Type
            else {
                return
            }
            let vc = cls.init()
            let nav = UINavigationController.init(rootViewController: vc)
            self?.present(nav, animated: true, completion: nil)
        }
    }
}

//MARK: tabbar与子视图相关
extension CustomTabBarController {
    func setupComposeButton() {
        let composeButton = UIButton.init(type: .custom)
        composeButton.setBackgroundImage(UIImage.init(named: "tabBar_publish_icon"), for: .normal)
        composeButton.setBackgroundImage(UIImage.init(named: "tabBar_publish_click_icon"), for: .highlighted)
        composeButton.sizeToFit()
        tabBar.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(composeClick), for: .touchUpInside)
        
        //计算按钮的frame
        composeButton.center.x = tabBar.center.x;
    }
    
    func setupChildController() {
        //拿到沙盒json路径
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docPath as NSString).appendingPathComponent("ccy.json")
        
        //加载data
        var data = NSData.init(contentsOfFile: jsonPath)
        //判断data是否为空，现实中到服务器请求界面配置，并存储到本地,有需要更改ccy.json
        if data == nil {
            //从bundle获取
            let bundlePath = Bundle.main.path(forResource: "ccy", ofType: "json")
            data = NSData.init(contentsOfFile: bundlePath!)
        }
        
        //data一定有值
        
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String : AnyObject]] else {
            return
        }
        
        //声明指定类型的数组
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(self.controller(dict: dict))
        }
        self.viewControllers = arrayM
    }
    
    private func controller(dict : [String : AnyObject]) -> UIViewController {
       guard let title = dict["title"] as? String,
        let className = dict["className"] as? String,
        let imageName = dict["imageName"] as? String,
        let selectedImageName = dict["selectedImage"] as? String,
        let cls = NSClassFromString("WeiBo." + className) as? BaseViewController.Type
        else {
           return UIViewController()
        }
        
        //创建视图控制器
        let vc = cls.init()
        vc.title = title
        tabBar.backgroundImage = UIImage.init(named: "tabbar-light")
        vc.tabBarItem.image = UIImage.init(named: imageName)
        vc.tabBarItem.selectedImage = UIImage.init(named: selectedImageName)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)], for: .normal)
    vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.darkGray], for: .selected)
        vc.visitorInfo = dict["visitorInfo"] as? [String : AnyObject]
        let nav = CustomNavigationController.init(rootViewController: vc)
        return nav
        
    }
}

//MARK: 开机界面相关
extension CustomTabBarController {
    
    func setupNewFeature() {
        
        isNewVersion() ? setupNewVersion() : setupWelcome()
        
    }
    
    private func isNewVersion() -> Bool {
        //取到当前的版本号
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        //取出存到本地版本号
        let sanboxVersion = UserDefaults.standard.value(forKey: "version") as? String
        
        //将当前版本号存储
        UserDefaults.standard.setValue(currentVersion, forKey: "version")
        
        return currentVersion != sanboxVersion
    }
    
    //新版本的界面
    private func setupNewVersion() {
        let v = NewVersionView.init(frame: UIScreen.main.bounds)
        self.view.addSubview(v)
    }
    
    //欢迎视图
    private func setupWelcome() {
        let v = CCYWelComeView.init(frame: UIScreen.main.bounds)
        view.addSubview(v)
    }
}
