//
//  Emotion.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import HandyJSON

class Emotion: NSObject {
    ///十六进制字符串，赋值emoji字符串
    var code : String? {
        didSet {
            guard let code = code else {
                return
            }
            let scanner = Scanner.init(string: code)
            var result : UInt32 = 0
            scanner.scanHexInt32(&result)
            
            emoji = String.init(Character(UnicodeScalar(result)!))
        }
    }
    
    //最近使用的次数
    var times : Int = 0
    
    //emoji字符串
    var emoji : String?
    
    ///表情字符串
    var chs : String?
    ///新浪表情图片名称
    var png : String?
    
    ///文件夹名字
    var directory : String?
    
    var image : UIImage? {
        guard let png = png,
            let directory = directory,
            let path = Bundle.main.path(forResource: "EmojiKeyBoard.bundle", ofType: nil),
            let bundle = Bundle.init(path: path)
            else {
            return nil
        }
        
        let image = UIImage.init(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)

        return image
    }

    
    override required init() {
    }
}

extension Emotion : HandyJSON {
    
}
