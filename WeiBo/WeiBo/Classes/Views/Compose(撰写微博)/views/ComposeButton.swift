//
//  ComposeButton.swift
//  WeiBo
//
//  Created by godyu on 2018/5/7.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class ComposeButton: UIControl {
    
    ///工具属性，按钮绑定的类名
    var className : String?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    class func compoeseButton(imageName: String, text : String) -> ComposeButton {
        
        let nib = UINib.init(nibName: "ComposeButton", bundle: Bundle.main)
        
        let btn = nib.instantiate(withOwner: nib, options: nil)[0] as! ComposeButton
        btn.backgroundColor = UIColor.clear
        
        btn.imageView.image = UIImage.init(named: imageName)
        btn.titleLabel.text = text
        
        return btn
    }
    

}
