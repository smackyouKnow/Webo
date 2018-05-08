//
//  UIBarButtonItem+Extension.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(text : String?, image : String?, selectedImage : String?, normalTextColor : UIColor?, selectedTextColor : UIColor?, target : AnyObject, selector : Selector) {
        let button = UIButton.init(type: .custom)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(normalTextColor, for: .normal)
        button.setTitleColor(selectedTextColor, for: .highlighted)
        if let image = image {
            button.setImage(UIImage.init(named: image), for: .normal)
        }
        if let selectedImage = selectedImage {
            button.setImage(UIImage.init(named: selectedImage), for: .highlighted)
        }
        
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.sizeToFit()
        button.contentHorizontalAlignment = .left
        
        self.init(customView: button)
    }
    
    convenience init(text : String?, image: String, normalTextColor : UIColor, highliedTextColor: UIColor, target : AnyObject, selector : Selector) {
        
        let button = UIButton.init(type: .custom)
        button.setTitle(text, for: .normal)
        button.setTitleColor(normalTextColor, for: .normal)
        button.setTitleColor(highliedTextColor, for: .highlighted)
        button.setBackgroundImage(UIImage.init(named: image), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.sizeToFit()
        
        button.addTarget(target, action: selector, for: .touchUpInside)
        self.init(customView: button)
    }
    
}
