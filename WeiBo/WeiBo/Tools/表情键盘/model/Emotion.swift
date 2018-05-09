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
    
    
    /// 将当前的图像转换生成富文本
    ///
    /// - Parameter font: 文字大小
    /// - Returns: 富文本
    func imageText(font : UIFont) -> NSAttributedString {
        guard let image = image else {
            return NSAttributedString.init(string: "")
        }
        
        let attachment = EmotionAttachment()
        attachment.chs = self.chs
        
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect.init(x: 0, y: -4, width: height, height: height)
        
        //返回图片属性文本
        let attrStrM = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: attachment))
        
        //设置字体属性
        attrStrM.addAttributes([NSAttributedStringKey.font : font], range: NSRange.init(location: 0, length: 1))
        
        return attrStrM
    }

    
    override required init() {
    }
}

extension Emotion : HandyJSON {
    
}
