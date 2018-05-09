//
//  EmoticonToollBar.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

@objc protocol EmoticonToollBarDelegate : NSObjectProtocol {
    func toolBarItemClickForIndex(index: Int)
}

class EmoticonToollBar: UIView {
    
    var selectedIndex : Int = 0 {
        didSet {
            for btn in subviews as! [UIButton]{
                btn.isEnabled = true
            }
            (subviews[selectedIndex] as! UIButton).isEnabled = false
        }
    }
    
    weak var delegate : EmoticonToollBarDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupToolBar()
    }
    
}


extension EmoticonToollBar {
    
    private func setupToolBar() {
        let packages = EmotionManager.shared.packages
        
        for (index, package) in packages.enumerated() {
            guard let package = package else {
                continue
            }
            
            let btn = UIButton.init(type: .system)
            btn.setTitle(package.name, for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.setTitleColor(UIColor.orange, for: .disabled)
            btn.frame = CGRect.init(x: CGFloat(index) * bounds.size.width / 4, y: 0, width: bounds.size.width / 4, height: bounds.size.height)
            btn.tag = index
            addSubview(btn)
            
            if index == 0 {
                btn.isEnabled = false
            }
            btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        }
    }
    
    @objc func click(sender : UIButton) {
        delegate?.toolBarItemClickForIndex(index: sender.tag)
    }
    
}
