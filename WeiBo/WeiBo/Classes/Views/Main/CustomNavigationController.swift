//
//  CustomNavigationController.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.isHidden = true
        self.interactivePopGestureRecognizer?.delegate = nil
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let button = UIButton.createButton(withText: "返回", fontSize: 16, normalTextColor: UIColor.black, highlightedColor: UIColor.red)
            button?.layer.borderWidth = 0
            button?.setImage(UIImage.init(named: "navigationButtonReturn"), for: .normal)
            button?.setImage(UIImage.init(named: "navigationButtonReturnClick"), for: .highlighted)
            button?.sizeToFit()
            button?.contentHorizontalAlignment = .left
            button?.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0)
            
            if  let vc = viewController as? BaseViewController {
                if viewControllers.count == 1 {
                    
                    button?.setTitle(childViewControllers.first?.title, for: .normal)
                }
                vc.navItem.leftBarButtonItem = UIBarButtonItem.init(customView: button!)
            }
            
            button?.addTarget(self, action: #selector(popClick), for: .touchUpInside)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func popClick() {
        popViewController(animated: true)
    }

}
