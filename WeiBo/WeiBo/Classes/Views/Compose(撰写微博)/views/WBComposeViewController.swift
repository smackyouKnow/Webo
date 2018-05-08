//
//  WBComposeViewController.swift
//  WeiBo
//
//  Created by godyu on 2018/5/7.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class WBComposeViewController: UIViewController {
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ComposeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        
    }


}

extension WBComposeViewController {
    
    private func setupUI() {
        setupNavgationBar()
        
        setupToolBar()
    }
    
    private func setupNavgationBar() {
        self.navigationItem.titleView = self.titleLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: ComposeButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(text: "返回", image: "buttonbar_back", normalTextColor: UIColor.darkGray, highliedTextColor: UIColor.orange, target: self, selector: #selector(back))
        self.ComposeButton.isEnabled = false
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }

    private func setupToolBar() {
        let images = [["imageName" : "synchronization_baoshi"],
                      ["imageName" : "synchronization_energy"],
                      ["imageName" : "synchronization_equipment"],
                      ["imageName" : "synchronization_feiyong", "actionName" :      "emotionKeyBoard"],
                      ["imageName" : "synchronization_finish"]]
        
        var items = [UIBarButtonItem]()
        
        for dict in images {
            let btn = UIButton.init(type: .system)
            
            guard let imageName = dict["imageName"] else {
                return
            }
            btn.setBackgroundImage(UIImage.init(named: imageName), for: .normal)
            btn.sizeToFit()
            
            let item = UIBarButtonItem.init(customView: btn)
            items.append(item)
            items.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        self.toolBar.items = items
    }
    
}
